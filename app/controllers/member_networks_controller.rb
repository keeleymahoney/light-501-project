class MemberNetworksController < ApplicationController
    before_action :authenticate_member!

    def authenticate_member!
        unless member_signed_in?
          redirect_to events_path, alert: "You need to sign in or sign up before continuing."
        end
      end

    def index
        if current_member.present?
            email = current_member.email
            @contact = Contact.find_by(email: email)

            if @contact.nil?
                flash[:alert] = "You do not currently have any network information available."
                    @contact = Contact.new(
                        id: -1,
                        first_name: "",
                        last_name: "",
                        email: "",
                        organization: "",
                        title: "",
                        link: "",
                        bio: "")
            end
        else
            flash[:alert] = "You need to sign in before accessing this page."
            redirect_to new_member_session_path
        end
    end

    def edit
        if current_member.present?
            email = current_member.email
            @contact = Contact.find_by(email: email)
            if @contact.nil?
                    @contact = Contact.new(
                        first_name: "",
                        last_name: "",
                        email: "",
                        organization: "",
                        title: "",
                        link: "",
                        bio: ""
                      )
                end
        else
            flash[:alert] = "You need to sign in before accessing this page."
            redirect_to new_member_session_path
        end
    end
  
  end