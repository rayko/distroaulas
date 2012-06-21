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
    flash[:notice] = show_notice :upload_space_types_success
    @import_results = SpaceType.import_xls params[:space_types][:file]
    render 'result'
  end

  def upload_spaces
    flash[:notice] = show_notice :upload_spaces_success
    @import_results = Space.import_xls params[:spaces][:file]
    render 'result'
  end

  def upload_plans
    flash[:notice] = show_notice :upload_plans_success
    @import_results = Plan.import_xls params[:plans][:file]
    render 'result'
  end

  def upload_careers
    flash[:notice] = show_notice :upload_careers_success
    @import_results = Career.import_xls params[:careers][:file]
    render 'result'
  end

  def upload_matters
    flash[:notice] = show_notice :upload_matters_success
    @import_results = Matter.import_xls params[:matters][:file]
    render 'result'
  end

  def result

  end


end
