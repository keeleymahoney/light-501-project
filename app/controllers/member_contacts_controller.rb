# frozen_string_literal: true

class MemberContactsController < ApplicationController
  before_action :authenticate_member!
    def index
      @contacts = Contact.all
    end
  
    def show
      @contact = Contact.find(params[:id])
    end
  
  end
  