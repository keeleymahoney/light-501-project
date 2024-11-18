# frozen_string_literal: true

class ApplicationController < ActionController::Base
    helper_method :admin_user?

    private
  
    def admin_user?
      # List of admin emails
      admin_emails = ['abhinavdevireddy@gmail.com', 'info.boldrso@gmail.com', 'keeley2403@tamu.edu', 'ryan.p_22@tamu.edu']
      current_member && admin_emails.include?(current_member.email)
    end
  
    # Restrict admin access
    def authenticate_admin!
      unless admin_user?
        redirect_to member_dashboard_path, alert: 'You do not have access to this page.'
      end
    end
end
