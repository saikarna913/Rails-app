# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_dashboard_index_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :admin)
  end
end
