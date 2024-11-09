# frozen_string_literal: true

class ContactsController < ApplicationController
  def index
    @contacts = Contact.all
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

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_url, notice: 'Contact was successfully destroyed.'
  end

  def delete
    @contact = Contact.find(params[:id])
  end

  # stuff
  def new_network_addition
    prev_contact = Contact.find_by(id: current_member.contact_id) 
    @contact = prev_contact.dup
    @contact.in_network = false
  end  

  # POST /requests/create_network_addition
  def create_network_addition
    # Find the existing contact of the current member
    prev_contact = Contact.find_by(id: current_member.contact_id)
    @contact = prev_contact.dup # Duplicate the contact information
    @contact.assign_attributes(contact_params)
    @contact.in_network = false # Mark as not in network until approved

    # Save the duplicated contact information
    if @contact.save
      # Create a new request for network addition
      @request = Request.new(
        request_type: 'network_addition',
        member: current_member,
        contacts_id: @contact.id,
        description: 'Requesting update to network information'
      )

      if @request.save
        redirect_to member_dashboard_path, notice: 'Network update request submitted successfully for admin approval.'
      else
        render :new_network_addition, alert: 'Failed to create network addition request.'
      end
    else
      render :new_network_addition, alert: 'Failed to save contact information.'
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
