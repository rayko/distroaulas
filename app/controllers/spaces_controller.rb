class SpacesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:ajax_free_spaces]

  def index
    @spaces = Space.paginate(:page => params[:page])
  end

  def show
    if params[:date]
      @date = Date.parse params[:date]
    else
      @date = Date.today
    end
    until @date.monday?
      @date -= 1.day
    end
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

  def ajax_free_spaces
    dtstart = DateTime.parse params[:start]
    dtend = DateTime.parse params[:end]
    free_spaces = Space.free_spaces :after => dtstart, :before => dtend, :overlapping => true
    respond_to do |format|
      format.json { render :json => free_spaces.to_json, :status => 200 }
    end
  end
end
