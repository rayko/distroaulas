class SpaceTypesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @space_types = SpaceType.paginate(:page => params[:page])
  end

  def new
    @space_type = SpaceType.new
  end

  def create
    @space_type = SpaceType.new(params[:space_type])
    if @space_type.save
      redirect_to @space_type, :notice => show_notice(:create_success)
    else
      render :action => 'new'
    end
  end

  def edit
    @space_type = SpaceType.find(params[:id])
  end

  def update
    @space_type = SpaceType.find(params[:id])
    if @space_type.update_attributes(params[:space_type])
      redirect_to @space_type, :notice  => show_notice(:update_success)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @space_type = SpaceType.find(params[:id])
    @space_type.destroy
    redirect_to space_types_url, :notice => show_notice(:destroy_success)
  end
end
