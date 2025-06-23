class DoctorsController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_to_doctor

  def dashboard
    @patients = Patient.all
    @patient_registrations = Patient.group_by_day(:created_at).count
  end
  def index
    @patients = Patient.all
    # Data for graph: patients registered per day
    @patient_registrations = Patient
      .group("DATE(created_at)")
      .count
      .transform_keys { |k| k.strftime("%Y-%m-%m") }
  end

  private

  def restrict_to_doctor
    unless current_user&.doctor?
      redirect_to root_path, alert: "You are not authorized to access the doctor dashboard."
    end
  end
end
