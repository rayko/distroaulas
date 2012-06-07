class EquipmentController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @equipment = Equipment.paginate(:page => params[:page])
  end

  def show
    @equipment = Equipment.find(params[:id])
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(params[:equipment])
    if @equipment.save
      redirect_to @equipment, :notice => "Successfully created equipment."
    else
      render :action => 'new'
    end
  end

  def edit
    @equipment = Equipment.find(params[:id])
  end

  def update
    @equipment = Equipment.find(params[:id])
    if @equipment.update_attributes(params[:equipment])
      redirect_to @equipment, :notice  => "Successfully updated equipment."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy
    redirect_to equipment_index_url, :notice => "Successfully destroyed equipment."
  end
end
