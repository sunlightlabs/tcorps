class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new params[:user_session]
    @user_session.save do |result|
      if result
        flash[:success] = 'You have been logged in.'
        redirect_to root_path
      else
        flash[:failure] = 'Invalid credentials.'
        render :action => :new
      end
    end
    
    # Would reach here if the OpenID service can't be discovered
    flash[:failure] = "Couldn't find OpenID server."
    redirect_to login_path
  end
  
  def destroy
    current_session.destroy
    flash[:success] = 'You have been logged out.'
    redirect_to root_path
  end
  
  # clickpass
  
  def begin_openid_login
    consumer = OpenID::Consumer.new session, OpenIdAuthentication::DbStore.new
    openid_url = OpenIdAuthentication.normalize_identifier params[:openid_url]
    
    request = consumer.begin openid_url
    redirect_to request.redirect_url(root_url, complete_openid_login_url)
  rescue OpenID::DiscoveryFailure
    # This code should never get reached (invalid OpenID server should have been detected on #create)
    flash[:failure] = "Couldn't find OpenID server."
    redirect_to login_path
  end
  
  def complete_openid_login
    consumer = OpenID::Consumer.new session, OpenIdAuthentication::DbStore.new
    openid_params = params.reject {|k, v| ['action', 'controller'].include? k}
    response = consumer.complete openid_params, request.url
    
    if response.status == OpenID::Consumer::SUCCESS
      if @user = User.find_by_openid_identifier(response.identity_url)
        UserSession.create @user
        flash[:success] = 'You have been successfully logged in.'
        redirect_to root_path
      else
        session[:working_openid] = response.identity_url
        redirect_to clickpass_register_url(User.new)
      end
    else
      # Not known why this would happen.
      flash[:failure] = "Invalid OpenID."
      redirect_to login_path
    end
  end

end