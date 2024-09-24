class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      member = Member.from_google(**from_google_params)
  
      email_domain = member.email.split('@').last
      if email_domain == 'tamu.edu'
        # Allow login if the email domain is tamu.edu
        if member.present?
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
        new_admin_session_path
    end

    def after_sign_in_path_for(resource_or_scope)
        stored_location_for(resource_or_scope) || root_path
    end

    private
  
    def from_google_params
        @from_google_params ||= {
            uid: auth.uid,
            email: auth.info.email,
            full_name: auth.info.name,
            avatar_url: auth.info.image
        }
    end

    def auth
        @auth ||= Rails.application.env_config['omniauth.auth'] || request.env['omniauth.auth']
      end
  end
  