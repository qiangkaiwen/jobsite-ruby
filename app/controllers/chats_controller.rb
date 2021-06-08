class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]
  before_filter :check_authentication

  def check_authentication
    unless session[:user]
      redirect_to '/'
    end
  end

  def msg
    chat = msg_ajax_params
    @chat = Chat.new(chat)
    if @chat.save
      render text:'success'
    else
      render text:'fail'
    end
  end

  # GET /chats
  def index
  end

  # GET /chats/1
  def show
    @baseUrl_userImage = '/assets/users/'
    job_id = params[:id]
    @job = Job.find(job_id)
    # @chat = Chat.new
    # @users = Hire.where(:job_id => job_id, :state_id=>5) # state_id=>5 : invitation
    @users = Hire.select('hires.id as hire_id, users.name
                    , sum(case when chats.read = 0 then 1 else 0 end) as unread_cnt')
                .from('hires')
                .joins('inner join users on users.id = hires.user_id')
                .joins('left join chats on chats.hire_id = hires.id')
                .group('hires.user_id')
                .where('hires.job_id = ?', job_id )
    if session[:user]['role'] == 'freelancer'
      @hire = Hire.where('job_id = ? AND user_id = ? AND state_id = 5' , job_id, session[:user]['id'])
      @hire_id = @hire[0].id

      @bids = Hire.where(:job_id => job_id, :state_id=>5, :user_id=>session[:user]['id'])
      @bids.update_all('invitation_read = 1')
      @chats = Chat.where('hire_id = ?', @hire_id)
      # @chats.update_all('read = 1')
    else
      @chats = []
      @bids = []
    end
  end

  def filter_by_user
    @baseUrl_userImage = '/assets/users/'
    ajax_params = filter_ajax_params
    @job = Job.find(ajax_params[:job_id])
    if session[:user]['role'] == 'freelancer'
      @chats = Chat.where('job_id = ? AND hire_id = ?', ajax_params[:job_id], ajax_params[:selected_hire_id])
      # @chats.update_all('read = 1')
    else
      @chats = Chat.where('job_id = ? AND hire_id = ?', ajax_params[:job_id], ajax_params[:selected_hire_id])
      @chats.update_all('read = 1')
      
    end
    
    render :_message, :layout => false
    # render :json => {:_message, :layout => false, :data =>'success' }
  end

  def bid_by_user
    ajax_params = filter_ajax_params
    @job = Job.find(ajax_params[:job_id])
    if (session[:user]['role'] == 'client' && ajax_params[:selected_hire_id].to_i > 0 )
      @hire = Hire.find(ajax_params[:selected_hire_id])
    end
    render :_bid, :layout => false
  end

  def kick_out
    ajax_params = kick_ajax_params
    Hire.where('job_id = ? AND state_id = 5 AND user_id = ?', ajax_params[:job_id], ajax_params[:kicked_user_id]).update_all('state_id = 1, invitation_read = 0');
    render text: 'success'
  end

  def check_kicked
    ajax_params = kick_ajax_params
    if session[:user]['id'].to_s == ajax_params[:kicked_user_id].to_s
      render text: 'kicked'
    else
      render text: 'alive'
    end
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats
  def create
    @chat = Chat.new(chat_params)

    if @chat.save
      render text:'success'
#      redirect_to @chat, notice: 'Chat was successfully created.'
    else
#      render :new
    end
  end

  # PATCH/PUT /chats/1
  def update
    if @chat.update(chat_params)
      redirect_to @chat, notice: 'Chat was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /chats/1
  def destroy
    @chat.destroy
    redirect_to chats_url, notice: 'Chat was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      # @chat = Chat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.require(:chat).permit(:content)
    end

    def msg_ajax_params
      params.require(:send_data).permit(:content, :user_id, :hire_id, :job_id)
    end

    def filter_ajax_params
      params.require(:send_data).permit(:selected_hire_id, :job_id)
    end

    def kick_ajax_params
      params.require(:send_data).permit(:kicked_user_id, :job_id)
    end

end
