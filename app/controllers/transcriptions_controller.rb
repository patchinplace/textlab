class TranscriptionsController < ApplicationController
  before_action :set_transcription, except: [ :index, :create ]
  before_action :authenticate_user!, except: :show

  def index
    # get the transcriptions for a given leaf for current user
    leaf_id = transcription_params[:leaf_id]
    leaf = Leaf.find(leaf_id)
    render json: leaf.get_transcription_objs( current_user.id )
  end

  # GET /transcriptions/1.json
  def show
    unless @transcription.document.can_view?( current_user )
      redirect_to root_url
      return
    end
    Rails.logger.info "******* The transcription obj is"
    Rails.logger.info @transcription.obj.inspect

    respond_to do |format|
      format.html {
        if @transcription.diplo.nil?
          @transcription.diplo = Diplo.create_diplo!( @transcription )
        end

        if @transcription.diplo.nil?
          render 'no_leaf'
          return
        end

        if @transcription.diplo.error
          @error_message = @transcription.diplo.html_content
          @name = @transcription.name
          render 'error', layout: 'tl_viewer'
          return
        end

        @transcription.save!
        @diplo_html = @transcription.diplo.html_content
        @title = @transcription.document.name
        @document_node = @transcription.leaf.document_node
        @prev_leaf = @document_node.prev_leaf
        @next_leaf =  @document_node.next_leaf
        @ancestor_nodes = @document_node.ancestor_nodes
        @node_title = @transcription.leaf.name
        stage_vals = @transcription.zones_hash.keys.map {|stage| @transcription.zones_hash[stage]["change"]}.uniq.compact.sort
        if params[:stage].present?
          @stages = @transcription.stages_hash(stage_vals[0..(stage_vals.index(params[:stage]))])
        else
          @stages = @transcription.stages_hash(stage_vals)
        end
        @all_stages_hash = JSON.parse(@transcription.document.project_config.vocabs)["stage"]
        @filtered_stages_hash = @all_stages_hash.select {|stage| stage_vals.include?(stage["value"])}
        unless @transcription.leaf.nil?
          @leaf = {
            xml_id: @transcription.leaf.xml_id,
            zones: @transcription.leaf.zones.where(zone_label: @stages.keys).map { |zone| zone.obj },
            tile_source: @transcription.leaf.tile_source,
            sequences: @transcription.leaf.published_sequence_objs,
            zone_hash: @stages,
          }
        else
          @leaf = {
            zones: [],
            tile_source: nil
          }
        end
        @relevant_zones = @stages.keys
        @irrelevant_zones = @transcription.leaf.zones.pluck(:zone_label) - @relevant_zones

        render layout: 'tl_viewer'
      }
      format.json { render json: @transcription.obj(current_user.id) }
    end
  end

  # POST /transcriptions.json
  def create
    @transcription = Transcription.new(transcription_params)
    @transcription.user = current_user

    if @transcription.save
      render json: @transcription.obj(current_user.id)
    else
      render json: @transcription.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transcriptions/1.json
  def update


    # clear cached diplo when editing transcription
    @transcription.diplo.delete if @transcription.diplo

    # excludes fields the user isn't authorized to edit
    filtered_params = @transcription.filter_by_permissions(transcription_params, current_user.id)

    if @transcription.update(filtered_params)
      render json: @transcription.obj(current_user.id)
    else
      render json: @transcription.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transcriptions/1.json
  def destroy
    if @transcription.destroy
      head :no_content
    else
      render json: @transcription.errors, status: :not_destroyed
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transcription
      @transcription = Transcription.find(params[:id])
    end

    def transcription_params
      params.permit( :leaf_id, :name, :content, :shared, :submitted, :document_id, :published )
    end
end
