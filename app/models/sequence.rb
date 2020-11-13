class Sequence < ActiveRecord::Base

  include EditingPermissions

  belongs_to :document
  belongs_to :user
  belongs_to :transcription
  has_many :narrative_steps, dependent: :destroy

  # tells editing permissions which fields contain writable content
  def content_fields
    [ :name ]
  end

  def list_obj
    {
      id: self.id,
      name: self.name,
      owner_name: self.user.attribution_name
    }
  end

  def published_obj
    steps = self.narrative_steps.order('step_number').map { |step| step.published_obj }

    {
      id: self.id,
      name: self.name,
      owner_name: self.user.display_name,
      narrative_steps: steps
    }
  end

  def obj(current_user_id=nil)

    steps = self.narrative_steps.order('step_number').map { |step| step.obj }
    owner = ( current_user_id == self.user_id )

    {
      id: self.id,
      name: self.name,
      shared: self.shared,
      submitted: self.submitted,
      published: self.published,
      narrative_steps: steps,
      owner: owner,
      owner_name: self.user.display_name,
      transcription: self.transcription.obj(current_user_id)
    }
  end

end
