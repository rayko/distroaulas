class CareersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @careers = Career.paginate(:page => params[:page])
  end

  def show
    @career = Career.find(params[:id])
  end

  def new
    @career = Career.new
  end

  def create
    @career = Career.new(params[:career])
    if @career.save
      redirect_to @career, :notice => "Successfully created career."
    else
      render :action => 'new'
    end
  end

  def edit
    @career = Career.find(params[:id])
  end

  def update
    @career = Career.find(params[:id])
    if @career.update_attributes(params[:career])
      redirect_to @career, :notice  => "Successfully updated career."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @career = Career.find(params[:id])
    @career.destroy
    redirect_to careers_url, :notice => "Successfully destroyed career."
  end

  def ajax_careers_by_plan
    @careers = Career.find :all, :conditions => {:plan_id => params[:id]}
    respond_to do |format|
      format.json { render :json => @careers.to_json, :status => 200}
    end
  end
end
