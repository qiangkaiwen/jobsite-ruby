class HiresController < ApplicationController
  before_action :set_hire, only: [:show, :edit, :update, :destroy]
  before_filter :check_authentication

  # GET /hires
  def index

  end

  def check_authentication
    unless session[:user]
      redirect_to '/'
      false
    end
    true
  end

  # GET /hires/1
  def show
    @states = State.all
    @job = Job.find(params[:id])
    @current_client = session[:user]['id'] == @job.user_id ? true : false
    @isRole_admin = session[:user]['role'] =='admin' ? true : false

    is_freelancer = session[:user]['role'] == 'freelancer'
    is_ever = Hire.where(:job_id => params[:id], :user_id => session[:user]['id']).length == 0
    is_new = @job.state_id == 1
    is_not_self = true # session[:user]['address'] != @job.user.address

    @user_can_bid = (is_freelancer and is_ever and is_new and is_not_self) ? true : false
    @hires = Hire.where(:job_id => params[:id])
    @hire = Hire.new
  end

  def suspend
    @job = Job.find(params[:id])
    @job.update_attribute(:state_id, 4)
    redirect_to '/hires/'+params[:id]
  end

  # GET /hires/1/invitation
  def invitation

    @hire = Hire.find(params[:id])
    respond_to do |format|
      if @hire.update_attribute(:state_id, 5) # 5=> invitation state:id
        format.json { render json: @hire.job, status: :created }
      else
        format.json { render json: @hire }
      end
    end
  end

  # GET /hires/1/hire
  def hire
    @hire = Hire.find(params[:id])
    job_id = @hire[:job_id]
    @hire.update_attribute(:state_id, 3) # 3=> hired state:id
    Job.find(job_id).update_attribute(:state_id, 3) # 3=> hired state:id
    redirect_to '/hires/'+job_id.to_s
  end

  # GET /hires/new
  def new
    @hire = Hire.new
  end

  # GET /hires/1/edit
  def edit
  end

  # POST /hires
  def create
    @hire = Hire.new(hire_params)
    @hire[:reg_date] = Time.now

    if @hire.save
      redirect_to '/hires/'+hire_params[:job_id], notice: 'Hire was successfully created.'
    else
      redirect_to '/hires/'+hire_params[:job_id], notice: 'Hire was not created.'
    end
  end

  # PATCH/PUT /hires/1
  def update
    if @hire.update(hire_params)
      redirect_to @hire, notice: 'Hire was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /hires/1
  def destroy
    @hire.destroy
    redirect_to hires_url, notice: 'Hire was successfully destroyed.'
  end

  def new_invitation
    if session[:user]['role'] == 'freelancer'
      @pre_hints = Hire.where(:state_id => 5, :user_id => session[:user]['id'], :invitation_read => 0)
      respond_to do |format|
        format.json { render json: @pre_hints }
      end
    else
      render text: 'fail'
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_hire
    # @hire = Hire.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def hire_params
    params.require(:hire).permit(:job_id, :user_id, :reg_date, :bid_content, :state_id)
  end
end
