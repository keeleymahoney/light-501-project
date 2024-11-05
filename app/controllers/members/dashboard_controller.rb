class Members::DashboardController < ApplicationController
    before_action :authenticate_member!

    def show
      # Dashboard logic goes here
      @member = current_member
      @requests = Request.where(member_id: @member.id)
    end
  
    private
  
    def authenticate_member!
      unless member_signed_in?
        redirect_to root_path, notice: 'You need to sign in to access the dashboard.'
      end
    end
  end
  