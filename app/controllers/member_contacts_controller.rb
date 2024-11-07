
class MemberContactsController < ApplicationController
  before_action :authenticate_member!
  before_action :check_network_access

  def authenticate_member!
    unless member_signed_in?
      redirect_to events_path, alert: "You need to sign in or sign up before continuing."
    end
  end

  def index
    @contacts = Contact.where(in_network: true)

    if params[:first_name].present?
      @contacts = @contacts.where('first_name ILIKE ?', "%#{params[:first_name]}%")
    end

    if params[:last_name].present?
      @contacts = @contacts.where('last_name ILIKE ?', "%#{params[:last_name]}%")
    end

    if params[:organization].present?
      @contacts = @contacts.where(organization: params[:organization])
    end

    if params[:industry].present?
      @contacts = @contacts.joins(:contacts_industries)
                       .joins("INNER JOIN industries ON industries.id = contacts_industries.industry_id")
                       .where(industries: { industry_type: params[:industry] })
    end

    @organizations = Contact.select(:organization).distinct.pluck(:organization)
    @industries = Industry.select(:industry_type).distinct.pluck(:industry_type)
  end

  def check_network_access
    if current_member.network_exp.nil? || current_member.network_exp < Date.today
      flash[:alert] = "You do not have access to the network."
      redirect_to member_dashboard_path
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end
end
  
  