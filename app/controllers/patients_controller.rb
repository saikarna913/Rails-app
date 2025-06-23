class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_to_receptionist, except: [ :index, :show ]
  before_action :set_patient, only: [ :show, :edit, :update, :destroy ]

  def index
    @patients = Patient.all
  end

  def show
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.user = current_user
    if @patient.save
      redirect_to patients_path, notice: "Patient was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to patients_path, notice: "Patient was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    redirect_to patients_path, notice: "Patient was successfully deleted."
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :date_of_birth, :medical_record_number)
  end

  def restrict_to_receptionist
    unless current_user&.receptionist?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
