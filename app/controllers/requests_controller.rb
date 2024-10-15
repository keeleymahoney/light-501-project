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

  # GET /requests/1/edit
  def edit; end

  # POST /requests or /requests.json
  def create
    @request = Request.new(request_params)
    @request.member = current_member

    respond_to do |format|
      if @request.save
        format.html { redirect_to request_url(@request), notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

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

  # Approve the request
  def approve
    @request = Request.find(params[:id])
    request_type = @request.request_type
    access_period = 6  # the number of months of access a user gets
    datetime = DateTime.current()  # get current date

    if request_type == "network_access"
      datetime = datetime.advance(months: access_period)  # set access x months out
      member = Member.find(@request.member_id)
      member.update(network_exp: datetime)
    elsif request_type == "constitution_access"
      datetime = datetime.advance(months: access_period)  # set access x months out
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
  def request_params
    params.require(:request).permit(:request_type, :description, :status)
  end
end
