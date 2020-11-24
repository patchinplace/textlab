class LeafsController < ApplicationController
  before_action :set_leaf, only: [:show, :update, :destroy, :download_facsimile]
  before_action :authenticate_user!

  # GET /leafs/1.json
  def show
    render json: @leaf.obj.to_json
  end

  # POST /leafs.json
  def create
    @leaf = Leaf.new(leaf_params)

    if @leaf.save
      render json: @leaf.obj(current_user.id)
    else
      render json: @leaf.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /leafs/1.json
  def update
    if @leaf.update(leaf_params)
      render json: @leaf.obj(current_user.id)
    else
      render json: @leaf.errors, status: :unprocessable_entity
    end
  end

  def download_facsimile
    if @leaf.tile_source.present?
      require 'open-uri'
      data = open(@leaf.medium_url).read
      send_data data, disposition: 'attachment', filename: "default.jpg"
    else
      head :no_content 
    end
  end

  # DELETE /leafs/1.json
  def destroy
    if @leaf.destroy
      head :no_content
    else
      render json: @leaf.errors, status: :not_destroyed
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leaf
      @leaf = Leaf.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaf_params
      params.permit( :name, :xml_id, :tile_source, :document_id, :next_zone_label )
    end
end
