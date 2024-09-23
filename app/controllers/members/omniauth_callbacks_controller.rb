class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      member = Member.from_google(from_google_params)
  
      if member.valid?
        sign_out_all_scopes
        flash[:success] = "Signed in successfully with TAMU email."
        sign_in_and_redirect member, event: :authentication
      else
        flash[:alert] = "Invalid email: #{member.errors.full_messages.join(', ')}"
        redirect_to new_member_session_path
      end
    end
  
    private
  
    def from_google_params
      auth = request.env['omniauth.auth']
      {
        uid: auth.uid,
        email: auth.info.email,
        name: auth.info.name,
        image: auth.info.image
      }
    end
  end
  