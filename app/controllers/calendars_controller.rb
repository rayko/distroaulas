class CalendarsController < ApplicationController
  def index
    @calendars = Calendar.all
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
    @calendar = Calendar.find(params[:id])
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(params[:calendar])
    if @calendar.save
      redirect_to @calendar, :notice => "Successfully created calendar."
    else
      render :action => 'new'
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])
  end

  def update
    @calendar = Calendar.find(params[:id])
    if @calendar.update_attributes(params[:calendar])
      redirect_to @calendar, :notice  => "Successfully updated calendar."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy
    redirect_to calendars_url, :notice => "Successfully destroyed calendar."
  end
end
