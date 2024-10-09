class MemberNetworksController < ApplicationController
    before_action :authenticate_member!

    def index
        if current_member.present?
            email = current_member.email
            @contact = Contact.find_by(email: email)
        else
            flash[:alert] = "You need to sign in before accessing this page."
            redirect_to new_member_session_path
        end
    end

    def edit
        if current_member.present?
            email = current_member.email
            @contact = Contact.find_by(email: email)
        else
            flash[:alert] = "You need to sign in before accessing this page."
            redirect_to new_member_session_path
        end
    end
  
  end