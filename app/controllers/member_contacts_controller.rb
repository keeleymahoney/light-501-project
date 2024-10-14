# frozen_string_literal: true

class MemberContactsController < ApplicationController
  before_action :authenticate_member!

  def authenticate_member!
    unless member_signed_in?
      redirect_to events_path, alert: "You need to sign in or sign up before continuing."
    end
  end

    def index
      @contacts = Contact.all
    end
  
    def show
      @contact = Contact.find(params[:id])
    end
  
  end
  