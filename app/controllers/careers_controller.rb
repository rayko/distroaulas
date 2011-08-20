class CareersController < ApplicationController
  def index
    @careers = Career.all
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
end
