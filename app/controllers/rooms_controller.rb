class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy, :enterRoom]

  def check_authentication
    unless session[:user]
      session[:intended_action] = action_name
      session[:intended_controller] = controller_name      
      redirect_to '/users'
      false
    end
    true
  end

  def check_entered
    unless session[:room]
      redirect_to '/rooms'
      false
    end
    true
  end

  @soc = UDPSocket.new
  @soc.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
  begin
    @soc.bind(nil, 1000)
    Thread.new do
      loop {
        text, sender = @soc.recvfrom(1024)
        @soc.send(text, 0, '<broadcast>', 1000)
        p text
      }
    end
  rescue
    p 'Only one usage of each socket address (protocol/network address/port) is normally permitted. - bind(2)'
  end


  # GET /rooms
  def index
    if session[:user]['role'] == 'admin'
      @jobs_per_user = Job.all
    elsif session[:user]['role'] == 'client'
      @jobs_per_user = Job.where(user_id: session[:user]['id'])
                          .order('reg_date DESC')

    elsif session[:user]['role'] == 'freelancer'
      @jobs_per_user = Job.select('jobs.*, hires.invitation_read, hires.id as hire_id')
                          .joins('inner join hires on hires.job_id=jobs.id')
                          .where(hires: {user_id: session[:user]['id'], :state_id => 5})
                          .order('reg_date DESC')
    end
    @categories = Category.all
  end

  def search_by_category
    if session[:user]['role'] == 'admin'
      @jobs_per_user = Job.all
    elsif session[:user]['role'] == 'client'
      @jobs_per_user = Job.where(user_id: session[:user]['id']).where(category_id: params[:id])
                          .order('reg_date DESC')

    elsif session[:user]['role'] == 'freelancer'
      @jobs_per_user = Job.joins('inner join hires on hires.job_id=jobs.id')
                           .where(category_id: params[:id])
                           .where(hires: {user_id: session[:user]['id'], :state_id => 5})
                           .order('reg_date DESC')
    end
    @categories = Category.all
    render '/rooms/index'
  end

  def enterRoom
    unless check_authentication
      return
    end
    session[:room] = @room
    time = Time.new
    session[:enterTime] = time.getutc.strftime('%Y-%m-%d %H:%M:%S %Z')
    redirect_to '/rooms/'+params['id']
  end

  # GET /rooms/1
  def show
    unless check_entered
      return
    end
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  
  # POST /rooms
  def create
    nroom_params = room_params
    str_image_url = room_params['image_url'].original_filename
    nroom_params['image_url'] = str_image_url
    p str_image_url.to_s
    nroom_params['user_id'] = session[:user]['id']
    @room = Room.new(nroom_params)
    Room.save( params[:room] )
    if @room.save
      redirect_to @room, notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      redirect_to @room, notice: 'Room was successfully updated.'
    else
      render :edit
    end
  end

  def msg
    chat = chat_params
    chat[:user_id] = session[:user]['id']
    chat[:room_id] = session[:room]['id']
    @chat = Chat.new(chat)

    if @chat.save
      p @chat.content
      render text:'success'
#      redirect_to @chat, notice: 'Chat was successfully created.'
    else
#      render :new
    end
  end

  # DELETE /rooms/1
  def destroy
    @room.destroy
    render text:'success'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def room_params
      params.require(:room).permit(:title, :image_url)
    end

    def chat_params
      params.require(:chat).permit(:content)
    end
end
