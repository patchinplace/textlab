class Document < ActiveRecord::Base
      	
  belongs_to :user
  has_many :leafs, dependent: :destroy
  has_many :document_sections, dependent: :destroy
  has_many :document_nodes, dependent: :destroy
  has_many :memberships, dependent: :destroy

  attr_writer :leaf_manifest
        
  def self.get_all( current_user )
		documents = Document.where( user_id: current_user.id )
		owned_docs = documents.map { |document| document.list_obj() }
    team_docs = current_user.memberships.map { |membership| membership.document.team_list_obj(membership) }
    (owned_docs + team_docs).sort_by { |doc| doc[:name] } 
	end  
  
  after_create do |document|
    root_section = DocumentSection.new
    root_section.document = self
    root_section.name = self.name
    root_section.save

    root_node = DocumentNode.new
    root_node.document = self
    root_node.position = 0
    root_node.document_section = root_section
    root_node.save

    # turn this into an array of leaves
    if @leaf_manifest
      position = 0
      manifest = JSON.parse(@leaf_manifest)
      manifest.each { |leaf_obj|
        leaf = Leaf.new({
          document: document,
          name: leaf_obj['name'],
          xml_id: leaf_obj['xml_id'],
          tile_source: leaf_obj['tile_source']
        })
        
        if leaf.save
          leaf_node = DocumentNode.new( {
            document: document,
            position: position,
            leaf: leaf,
            document_node_id: root_node.id
          })
          leaf_node.save! 
          position = position + 1
        end
      } 
    end
  end
  
  def is_owner?(current_user_id)
    ( !self.user_id.nil? && self.user_id == current_user_id )
  end
  
  def is_member?(current_user_id)
    self.memberships.where( user_id: current_user_id ).length > 0  
  end  
  
  def can_view?(current_user)
    self.published || (!current_user.nil? && ( self.is_owner?(current_user.id) || self.is_member?(current_user.id) ))
  end
  
  def root_node
    self.document_nodes.where({ document_node_id: nil, document_id: self.id }).first
  end
  
  def child_sections
    self.root_node.child_nodes.order(:position).map { |child_node|  
      child_node.document_section
    }.compact
  end

  def team_list_obj( membership )
    {
      id: self.id,
      name: self.name,
      description: self.description,
      owner_name: self.user.email,
      membership_id: membership.id,
      accepted: membership.accepted,
      root_node: root_node.document_section_id,
      owner: false
    }
  end
      
  def list_obj()
    { 
      id: self.id,
      name: self.name,
      description: self.description,
      owner: true,
      root_node: root_node.document_section_id,
      published: self.published
    }
  end
  
  def obj(current_user_id=nil)
    leafsJSON = self.leafs.map { |leaf| leaf.obj }
    sectionsJSON = self.document_sections.map { |section| section.obj }
    nodesJSON = self.document_nodes.map { |node| node.obj }
    membersJSON = self.memberships.map { |membership| membership.obj }
    
    { 
      id: self.id,
      name: self.name,
      description: self.description,
      leafs: leafsJSON,
      sections: sectionsJSON,
      document_nodes: nodesJSON,
      members: membersJSON,
      owner: self.is_owner?(current_user_id),
      published: self.published
    }
  end
 
  
end