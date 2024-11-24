# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :authenticate_admin!, only: %i[index new create edit update destroy]
  def index
    @organizations = Contact.select(:organization).distinct.pluck(:organization)
    @industries = Industry.select(:industry_type).distinct.pluck(:industry_type)
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

    if params[:in_network].present?
      in_network_value = ActiveModel::Type::Boolean.new.cast(params[:in_network])
      @contacts = @contacts.where(in_network: in_network_value)
    end

    if params[:industry].present?
      @contacts = @contacts.joins(:contacts_industries)
                       .joins("INNER JOIN industries ON industries.id = contacts_industries.industry_id")
                       .where(industries: { industry_type: params[:industry] })
    end

    
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end


  def create
    @contact = Contact.new(contact_params)
  
    if @contact.save
      associate_industries(@contact, params[:contact][:industries])
      redirect_to @contact, notice: 'Contact was successfully created.'
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update(contact_params)
      associate_industries(@contact, params[:contact][:industries])
      redirect_to @contact, notice: 'Contact was successfully updated.'
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
# Try catch error handling for contact deletion
  def destroy
    @contact = Contact.find(params[:id])
    begin
      @contact.destroy
      redirect_to contacts_url, notice: 'Contact was successfully destroyed.'
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:alert] = "Cannot delete this contact because it is still being referenced as a member."
      redirect_to contacts_url
    end
  end  

  def delete
    @contact = Contact.find(params[:id])
  end

  # stuff
  def new_network_addition
    prev_contact = Contact.find_by(id: current_member.contact_id) 
    @contact = prev_contact.dup
    # @contact.pfp.attach(prev_contact.pfp.blob)
    @contact.in_network = false
  end  

  # POST /requests/create_network_addition
def create_network_addition  
  # Find the related contact for the member
    # prev_contact = Contact.find_by(id: current_member.contact_id) 
    # @contact = prev_contact.dup
  prev_contact = Contact.find_by(id: current_member.contact_id)
  @contact = Contact.new(contact_params)
  unless @contact.pfp.attached?
    @contact.pfp.attach(prev_contact.pfp.blob)
  end
  @contact.in_network = false

  unless @contact.save
    render :new_network_addition
  end

  @request = Request.new(request_type: 'network_addition', contacts_id: @contact.id)
  @request.member = current_member

  if @request.save
    redirect_to member_dashboard_path, notice: 'Network addition request was successfully created.'
  else
    render :new_network_addition
  end
end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :organization, :title, :link, :bio, :email, :in_network, :pfp)
  end

  def associate_industries(contact, industries)
    return unless industries

    industries.split(',').each do |industry_name|
      industry = Industry.find_or_create_by(industry_type: industry_name.strip.downcase)
      contact.industries << industry unless contact.industries.include?(industry)
    end
  end
end
