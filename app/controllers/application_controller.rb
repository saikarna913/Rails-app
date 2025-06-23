class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    case resource.role
    when "admin"
      admin_dashboard_index_path
    when "receptionist"
      patients_path
    when "doctor"
      doctors_index_path
    else
      sign_out(resource)
      handle_invalid_role(resource)
    end
  end

  private

  def handle_invalid_role(resource)
    # Add error to the user model
    resource.errors.add(:base, "Your account has an invalid role (#{resource.role}). Please contact the administrator.")

    # Sign out the user
    sign_out(resource)

    # Store the resource with errors in the session to access in the SessionsController
    session[:invalid_role_resource] = resource.attributes
    session[:invalid_role_errors] = resource.errors.to_hash

    new_user_session_path
  end
end
