class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    member = Member.from_google(email: auth.info.email, full_name: auth.info.name, admin: false)
    
    # Update token if expired, create token if it doesn't exist (should be exclusive to admin)
    if !member.token.nil?
      member.token.update(access_token: auth.credentials.token, token_exp: auth.credentials.expires_at)
    else
      member.create_token(access_token: auth.credentials.token, token_exp: auth.credentials.expires_at)
    end

    email_domain = member.email.split('@').last

    admin_emails = ['abhinavdevireddy@gmail.com', 'info.boldrso@gmail.com', 'keeley2403@tamu.edu', 'ryan.p_22@tamu.edu']

    if email_domain == 'tamu.edu' || admin_emails.include?(member.email)
      # Allow login for tamu.edu and admins
      if member.present?
        member.update(admin: admin_emails.include?(member.email)) # Set to admin
        sign_out_all_scopes
        flash[:success] = 'Signed in successfully via Google.'
        sign_in_and_redirect member, event: :authentication
      else
        flash[:alert] = 'You are not authorized to sign in.'
        redirect_to new_member_session_path
      end
    else
      # Reject the login if the email domain is not tamu.edu
      flash[:alert] = 'You must log in with a tamu.edu email address.'
      redirect_to root_path
    end
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_member_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def from_google_params
    @from_google_params ||= {
      email: auth.info.email,
      full_name: auth.info.name
    }
  end

  def auth
    @auth ||= Rails.application.env_config['omniauth.auth'] || request.env['omniauth.auth']
  end
end
