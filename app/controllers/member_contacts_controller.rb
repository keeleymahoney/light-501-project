
class MemberContactsController < ApplicationController
  before_action :authenticate_member!

  def authenticate_member!
    unless member_signed_in?
      redirect_to events_path, alert: "You need to sign in or sign up before continuing."
    end
  end

  def index
    @contacts = Contact.all

    if params[:first_name].present?
      @contacts = @contacts.where('first_name ILIKE ?', "%#{params[:first_name]}%")
    end

    if params[:last_name].present?
      @contacts = @contacts.where('last_name ILIKE ?', "%#{params[:last_name]}%")
    end

    if params[:organization].present?
      @contacts = @contacts.where(organization: params[:organization])
    end

    @organizations = Contact.select(:organization).distinct.pluck(:organization)
  end

  def show
    @contact = Contact.find(params[:id])
  end
end
  
  