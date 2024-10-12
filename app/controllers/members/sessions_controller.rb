# app/controllers/members/sessions_controller.rb
class Members::SessionsController < Devise::SessionsController
  # Redirect to events page after signing out
  def after_sign_out_path_for(_resource_or_scope)
    new_member_session_path # Redirect to sign in page
  end

  # Redirect to the events index page after signing in
  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path # Redirect to events page
  end
end
