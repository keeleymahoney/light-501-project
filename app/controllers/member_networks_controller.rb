class MemberNetworksController < ApplicationController
    before_action :authenticate_member!

    def authenticate_member!
        unless member_signed_in?
          redirect_to events_path, alert: "You need to sign in or sign up before continuing."
        end
      end
=begin
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
=end

    def index
        if current_member.present?
        # Fetch the most recent approved contact marked as in_network
        #@contact = Contact.find_by(email: current_member.email, in_network: true)
        @contact = Contact.where(email: current_member.email, in_network: true)
                          .order(updated_at: :desc)
                          .first

        if @contact.nil?
            flash[:alert] = "You do not currently have any network information available."
            redirect_to member_dashboard_path
        end
        else
        flash[:alert] = "You need to sign in before accessing this page."
        redirect_to new_member_session_path
        end
    end

    def edit
        if current_member.present?
        @contact = Contact.find_by(email: current_member.email, in_network: true)
        if @contact.nil?
            flash[:alert] = "No contact information available to edit."
            redirect_to member_dashboard_path
        end
        else
        flash[:alert] = "You need to sign in before accessing this page."
        redirect_to new_member_session_path
        end
    end

  end