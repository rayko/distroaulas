class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.paginate(:page => params[:page])
  end

  def new
    @user = User.new
  end

  def reset_pass
    @user = User.find(params[:user_id])
    authorize! :reset_pass, @user
  end

  def update_pass
    @user = User.find(params[:user_id])
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice  => show_notice(:reset_pass_success)
    else
      render :action => 'reset_pass'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user, :notice => show_notice(:create_success)
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :notice  => show_notice(:update_success)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, :notice => show_notice(:destroy_success)
  end

end
