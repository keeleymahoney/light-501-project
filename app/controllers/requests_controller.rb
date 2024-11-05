class RequestsController < ApplicationController
  before_action :set_request, only: %i[show edit update destroy approve deny]

  # GET /requests or /requests.json
  def index
    @requests = Request.all
    @members = Member.all

    if params[:request_type].present?
      @requests = @requests.where(request_type: params[:request_type])
    end

    if params[:status].present?
      @requests = @requests.where(status: params[:status])
    end
  end

  # GET /requests/1 or /requests/1.json
  def show
    @request = Request.find(params[:id])
    @member = Member.find(@request.member_id)
    @contact = Contact.find(@member.contact_id)
    if @request.contacts_id != nil
      @contact_id = @request.contacts_id
      @updated_contact = Contact.find(@request.contacts_id)
      @organization = @updated_contact.organization
    end
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/new_network_access
  def new_network_access
    @request = Request.new(request_type: 'network_access')
  end

  # GET /requests/new_constitution_access
  def new_constitution_access
    @request = Request.new(request_type: 'constitution_access')
  end

  # GET /requests/new_network_addition
  def new_network_addition
    prev_contact = Contact.find_by(id: current_member.contact_id) 
    @contact = prev_contact.dup
    @contact.in_network = false
    @request = Request.new(request_type: 'network_addition', contacts_id: @contact.id)
  end  

  # GET /requests/1/edit
  def edit; end

  # POST /requests or /requests.json
  def create
    @request = Request.new(request_params)
    @request.member = current_member

    respond_to do |format|
      if @request.save
        format.html { redirect_to member_dashboard_path, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

# POST /requests/create_network_addition
=begin
def create_network_addition
  @request = Request.new(request_params)
  @request.request_type = 'network_addition'
  @request.member = current_member
  
  # Find the related contact for the member
  prev_contact = Contact.find_by(id: current_member.contact_id) 
  @contact = prev_contact.dup
  @contact.in_network = false

  unless @contact.save
    render :new_network_addition
  end

  @request.contacts_id = @contact.id

  if @request.save
    redirect_to @request, notice: 'Network addition request was successfully created.'
  else
    render :new_network_addition
  end
end
=end

=begin
def create_network_addition
  # Create a duplicate contact with the updated information
  prev_contact = Contact.find_by(id: current_member.contact_id)
  @contact = prev_contact.dup
  @contact.assign_attributes(contact_params)
  @contact.in_network = false

  if @contact.save
    # Associate the new contact with the request
    @request = Request.new(request_params)
    @request.member = current_member
    @request.contacts_id = @contact.id

    if @request.save
      redirect_to @request, notice: 'Network addition request was successfully created.'
    else
      render :new_network_addition
    end
  else
    render :new_network_addition
  end
end
=end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to request_url(@request), notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete
    @request = Request.find(params[:id])
    @member = Member.find(@request.member_id)
    unless @request.contacts_id == nil
      @contact = Contact.find(@request.contacts_id)
    end
  end

  def approve
    @request = Request.find(params[:id])
    request_type = @request.request_type
    access_period = 6  # the number of months of access a user gets
    datetime = DateTime.current().end_of_day()  # get current date

    if request_type == "network_access"
      datetime += 3.months  # set access x months out
      member = Member.find(@request.member_id)
      member.update(network_exp: datetime)
    elsif request_type == "constitution_access"
      datetime += 1.day  # set access x months out
      member = Member.find(@request.member_id)
      member.update(constitution_exp: datetime)
    elsif request_type == "network_addition"
      member = Member.find(@request.member_id)
      contact = Contact.find(member.contact_id)
      contact.update(in_network: true)
    end

    @request.update(status: :accepted)
    redirect_to @request, notice: 'Request was successfully approved.'
  end

  # Deny the request
  def deny
    @request = Request.find(params[:id])
    @request.update(status: :rejected)
    redirect_to @request, notice: 'Request was successfully denied.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = Request.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
=begin
  def request_params
    params.require(:request).permit(:request_type, :description, :status, contact_attributes: [:first_name, :last_name, :organization, :title, :link, :bio, :email, :pfp_file, :in_network])
  end
=end

  def request_params
    params.require(:request).permit(:request_type, :description, :status)
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :organization, :title, :email, :link, :bio)
  end

  #
end
