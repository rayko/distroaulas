class SpacesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @spaces = Space.all
  end

  def show
    @space = Space.find(params[:id])
  end

  def new
    @space = Space.new
  end

  def create
    @space = Space.new(params[:space])
    if @space.save
      redirect_to @space, :notice => "Successfully created space."
    else
      render :action => 'new'
    end
  end

  def edit
    @space = Space.find(params[:id])
  end

  def update
    @space = Space.find(params[:id])
    if @space.update_attributes(params[:space])
      redirect_to @space, :notice  => "Successfully updated space."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @space = Space.find(params[:id])
    @space.destroy
    redirect_to spaces_url, :notice => "Successfully destroyed space."
  end
end
