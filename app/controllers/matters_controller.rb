class MattersController < ApplicationController
  def index
    @matters = Matter.all
  end

  def show
    @matter = Matter.find(params[:id])
  end

  def new
    @matter = Matter.new
  end

  def create
    @matter = Matter.new(params[:matter])
    if @matter.save
      redirect_to @matter, :notice => "Successfully created matter."
    else
      render :action => 'new'
    end
  end

  def edit
    @matter = Matter.find(params[:id])
  end

  def update
    @matter = Matter.find(params[:id])
    if @matter.update_attributes(params[:matter])
      redirect_to @matter, :notice  => "Successfully updated matter."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @matter = Matter.find(params[:id])
    @matter.destroy
    redirect_to matters_url, :notice => "Successfully destroyed matter."
  end

  def ajax_get_matters_by_career
    @matters = Matter.find :all, :conditions => {:career_id => params[:id]}
    respond_to do |format|
      format.json { render :json => @matters.to_json, :status => 200 }
    end
  end

end
