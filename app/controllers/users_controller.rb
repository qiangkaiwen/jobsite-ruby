
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    session[:user] = nil
    redirect_to '/jobs'
    # @users = User.all

  end


  # GET /users/1
  def show
    @job_per_user = Job.where(:user_id => params[:id])
    @hire_per_user = Hire.where(:user_id => params[:id])

    @edit_button_show = 0
    if session[:user]['id'].to_s == params[:id]
      @edit_button_show = 1
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @user.password = ''
  end

  def login
    logUser = user_params
    @user = User.authenticate(logUser[:name], logUser[:password])
    if @user
      session[:user] = @user
      redirect_to '/jobs'
    else
      @notice = 'Login Failed'
      index
    end
  end
  
  # GET /users/1/edit
  def edit
  end

  def update_user_params
    new_user = user_params
    (user_params['image_url'] == nil)? new_user['image_url'] = 'anonymous.png': new_user['image_url'] = user_params['image_url'].original_filename
    new_user[:salt] = [Array.new(6){rand(256).chr}.join].pack('m').chomp
    new_user[:password] = Digest::SHA256.hexdigest(user_params[:password] + new_user[:salt])
    new_user[:password_confirmation] = Digest::SHA256.hexdigest(user_params[:password_confirmation] + new_user[:salt])

    new_user
  end

  # POST /users
  def create

    nuser = update_user_params()
    nuser[:address] = request.remote_ip
    exist = User.identify_user(nuser[:name])
    @user = User.new(nuser)
    if exist == 'true'
      if @user.save
        upload_image(params[:user])
        redirect_to '/users'
      else
        @notice = 'Sorry, Sign up failed'
        render(:template => 'users/new')
      end  
    else
      @notice = nuser[:name]+' already exists'
      render(:template => 'users/new')
    end
 
  end

  # PATCH/PUT /users/1
  def update
    nuser = update_user_params()
    if @user.update(nuser)
      session[:user] = @user
      upload_image(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def upload_image(upload)
    if upload['image_url'] != nil
      name = upload['image_url'].original_filename
      directory = 'app/assets/images/users'
      path = File.join(directory, name)
      File.open(path, 'wb') { |f| f.write(upload['image_url'].read) }
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def management
    @users = User.all
    render :_management
  end

  def exchange_used

    user_id = ajax_exchange_used_params[:user_id]
    @user = User.find(user_id)
    update_state = @user[:used] == 1 ? 0 : 1
    @user.update_attribute(:used, update_state)

    render text:'success'
  end

  # def address_update
    
  #   user_name = params[:send_data]['user_name']
  #   @user = User.where(:name => user_name.to_s)
  #   address = params[:send_data]['remoteAddress']
  #   if @user != nil
  #     @user.update_all('address = ' + address.to_s)
  #   end
  #   render text:'success'
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :salt, :image_url, :location, :role, :skill)
    end

    def ajax_exchange_used_params
      params.require(:send_data).permit(:user_id)
    end

end
