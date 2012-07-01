class AdministrationController < ApplicationController
  before_filter :authenticate_user!, :check_role

  def index
  end

  def statics
    @events_count = Event.count
    @matters_count = Matter.count
    @careers_count = Career.count
    @plans_count = Plan.count
    @spaces_count = Space.count
    @calendars_count = Calendar.count
    @equipment_count = Equipment.count
    @expired_events = Event.expired_events_count
    @assigned_matters = Matter.with_events_count
    @free_events = Event.free_events_count
    @assigned_spaces = Space.with_events_count
    @unassigned_spaces = Space.with_no_events_count
    @unassigned_matters = Matter.with_no_events_count
    @user_count = User.count
    @admin_count = User.admin_count
    @op_count = User.op_count
    @normal_users_count = User.user_count

  end

  private
  def check_role
    if current_user.role != 'admin'
      redirect_to root_path, :alert => show_alert(:permission_denied)
    end
  end
end
