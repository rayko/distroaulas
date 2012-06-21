class CalendarsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @calendars = Calendar.paginate(:page => params[:page])
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
      redirect_to @calendar, :notice => show_notice(:create_success)
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
      redirect_to @calendar, :notice  => show_notice(:update_success)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy
    redirect_to calendars_url, :notice => show_notice(:destroy_success)
  end
end
