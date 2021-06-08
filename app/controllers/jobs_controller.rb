class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  @@selected_category, @@selected_state = '0', '0'
  @@remembered_string = '0'
  # GET /jobs
  def index
    # @jobs = Job.order('reg_date DESC').order('state_id ASC').limit(5).offset(0)
    @jobs = Job.all.order('reg_date DESC').order('state_id ASC').paginate(:page => params[:page], :per_page => 5)
    # @jobs = Job.order('reg_date DESC').order('state_id ASC').all
    @categories = Category.all
    @states = State.take(4)
    @search = 'search'
  end

  # GET /jobs/1
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  def initialize_view
    @states = State.take(4)
    @categories = Category.all
    @search = 'search'
    render '/jobs/jobs', :layout => false
  end

  def search
    last_letter = params[:id].at(-2..-1)
    (last_letter == '@c')? @@selected_category = params[:id].at(0..-3) : ''
    (last_letter == '@s')? @@selected_state = params[:id].at(0..-3) : ''
    (last_letter == '@t')? @@remembered_string = params[:id].at(0..-3) : ''

    @jobs = Job.where((@@selected_category != '0')? {:category_id => @@selected_category} : 'category_id IS NOT NULL')
                .where((@@selected_state != '0')? {:state_id => @@selected_state} : 'state_id IS NOT NULL')
                .where((@@remembered_string != '0')? "title LIKE '%#{@@remembered_string}%' OR description LIKE '%#{@@remembered_string}%'" : 'title IS NOT NULL')
                .order('reg_date DESC')
                .order('state_id ASC')
                .paginate(:page => params[:page], :per_page => filter_params[:limit])
    initialize_view
  end

  # POST /jobs
  def create
  end

  def create_new_job
    @categories = Category.all
    @job = Job.new(job_params)
    @job[:reg_date] = Time.now
    @userName = User.find(job_params[:user_id])
    @categoryName = Category.find(job_params[:category_id])
    if @job.save
      @data = {:jobId => @job[:id], :title => @job[:title], :description => @job[:description], :reg_date => @job[:reg_date], :userId => @job[:user_id], :userName => @userName[:name], :categoryName => @categoryName[:category_name]}
      render json: @data
    else
      render :new
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /jobs/1
  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def job_params
    params.require(:send_data).permit(:title, :description, :skills, :user_id, :state_id, :category_id)
  end
  def filter_params
    params.require(:send_data).permit(:limit)
  end
end
