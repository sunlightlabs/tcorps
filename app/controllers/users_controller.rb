class UsersController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:process_openid_registration, :add_openid_to_user]
  
  before_filter :require_login, :only => [:edit, :update]
  before_filter :require_self, :only => [:edit, :update]

  def index
    @users = User.by_points.leaders.all
    @groups = @users.group_by {|u| u.level}
    @max_level = @users.any? ? [@users.first.level + 1, LEVELS.keys.size].min : 1
    @levels = (1..@max_level).to_a.reverse
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    @user.save do |result|
      if result
        # log them in
        UserSession.create @user
        
        flash[:success] = 'Your account has been created, and you have been logged in.'
        redirect_to root_path
      else
        render :action => :new
      end
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Your profile has been updated.'
      redirect_to edit_user_path(@user)
    else
      render :action => :edit
    end
  end
  
  # clickpass
  
  def process_openid_registration
    unless params[:clickpass_openid] and params[:clickpass_openid] == session[:working_openid]
      flash[:failure] = 'Invalid OpenID.'
      redirect_to root_path and return
    end
    
    @user = User.new :login => params[:nickname], :openid_identifier => params[:clickpass_openid], :email => params[:email]
    # done with #valid? and #save! so that authlogic-oid doesn't attempt to re-authenticate the openid
    if @user.valid?
      @user.save!
      UserSession.create @user
      
      flash[:success] = 'Your account has been created, and you have been logged in'
      redirect_to root_path
    else
      redirect_to clickpass_register_url(@user)
    end
  end
  
  def add_openid_to_user
    unless params[:openid_url] and params[:openid_url] == session[:working_openid]
      redirect_to "#{params[:clickpass_merge_callback_url]}&openid_authenticated=false" and return
    end
    
    @user_session = UserSession.new :login => params[:user_id], :password => params[:password]
    if @user_session.save
      current_user.update_attribute :openid_identifier, session[:working_openid]
      session[:working_openid] = nil
      
      # updating the user apparently invalidates authlogic's session, so we make a new one
      UserSession.create current_user
      
      flash[:success] = "You have been successfully logged in."
      redirect_to root_path
    else
      redirect_to "#{params[:clickpass_merge_callback_url]}&userid_authenticated=false"
    end
  end
  
  protected
  
  def require_self
    unless (@user = User.find_by_id(params[:id])) and logged_in? and (@user == current_user)
      flash[:failure] = "You do not have permission to edit this user's profile."
      redirect_to root_path and return false
    end
  end
  
end