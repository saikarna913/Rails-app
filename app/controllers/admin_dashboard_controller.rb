class AdminDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_to_admin

  def index
    @user_count = User.count
    @patient_count = Patient.count
    @receptionist_count = User.where(role: "receptionist").count
    @doctor_count = User.where(role: "doctor").count
  end

  def users
    @users = User.all
  end

  def update_user_role
    @user = User.find(params[:user_id])
    if @user.update(role: params[:role])
      redirect_to admin_dashboard_users_path, notice: "User role updated successfully."
    else
      flash.now[:alert] = "Failed to update user role: #{@user.errors.full_messages.join(', ')}."
      @users = User.all
      render :users, status: :unprocessable_entity
    end
  end

  private

  def restrict_to_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to access the admin dashboard."
    end
  end
end
