class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      member = Member.from_google(request.env['omniauth.auth'])  

      if member.present?
        sign_out_all_scopes
        flash[:success] = 'Signed in successfully via Google.'
        sign_in_and_redirect member, event: :authentication
      else
        flash[:alert] = "You are not authorized to sign in."
        redirect_to new_member_session_path
      end
    end
  
    protected
  
    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || root_path
    end
  
    private
  
    def from_google_params
      auth = request.env['omniauth.auth']
      {
        uid: auth.uid,
        email: auth.info.email,
        full_name: auth.info.name,
        avatar_url: auth.info.image
      }
    end
  end
  