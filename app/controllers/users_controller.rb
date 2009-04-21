class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    @user.save do |result|
      if result
        flash[:success] = 'Your account has been created, and you have been logged in.'
        redirect_to root_path
      else
        render :action => :new
      end
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
      
      flash[:success] = "You have been successfully logged in."
      redirect_to root_path
    else
      redirect_to "#{params[:clickpass_merge_callback_url]}&userid_authenticated=false"
    end
  end
  
end