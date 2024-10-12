class ContactsIndustriesController < ApplicationController
  before_action :set_contacts_industry, only: %i[show edit update destroy]

  # GET /contacts_industries or /contacts_industries.json
  def index
    @contacts_industries = ContactsIndustry.all
  end

  # GET /contacts_industries/1 or /contacts_industries/1.json
  def show; end

  # GET /contacts_industries/new
  def new
    @contacts_industry = ContactsIndustry.new
  end

  # GET /contacts_industries/1/edit
  def edit; end

  # POST /contacts_industries or /contacts_industries.json
  def create
    @contacts_industry = ContactsIndustry.new(contacts_industry_params)

    respond_to do |format|
      if @contacts_industry.save
        format.html do
          redirect_to contacts_industry_url(@contacts_industry), notice: 'Contacts industry was successfully created.'
        end
        format.json { render :show, status: :created, location: @contacts_industry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contacts_industry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts_industries/1 or /contacts_industries/1.json
  def update
    respond_to do |format|
      if @contacts_industry.update(contacts_industry_params)
        format.html do
          redirect_to contacts_industry_url(@contacts_industry), notice: 'Contacts industry was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @contacts_industry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contacts_industry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts_industries/1 or /contacts_industries/1.json
  def destroy
    @contacts_industry.destroy

    respond_to do |format|
      format.html { redirect_to contacts_industries_url, notice: 'Contacts industry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contacts_industry
    @contacts_industry = ContactsIndustry.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contacts_industry_params
    params.fetch(:contacts_industry, {})
  end
end
