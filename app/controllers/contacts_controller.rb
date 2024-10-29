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

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :organization, :title, :bio, :email, :in_network)
  end

  def associate_industries(contact, industries)
    return unless industries

    industries.split(',').each do |industry_name|
      industry = Industry.find_or_create_by(industry_type: industry_name.strip.downcase)
      contact.industries << industry unless contact.industries.include?(industry)
    end
  end
end
