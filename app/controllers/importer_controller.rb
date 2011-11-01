class ImporterController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def space_types
  end

  def spaces
  end

  def plans
  end

  def careers
  end

  def matters
  end

  def upload_space_types
    flash[:notice] = "File uploaded successfuly."
    @import_results = SpaceType.import_xls params[:space_types][:file]
    render 'result'
  end

  def upload_spaces
    flash[:notice] = "File uploaded successfuly."
    @import_results = Space.import_xls params[:spaces][:file]
    render 'result'
  end

  def upload_plans
    flash[:notice] = "File uploaded successfuly."
    @import_results = Plan.import_xls params[:plans][:file]
    render 'result'
  end

  def result

  end


end
