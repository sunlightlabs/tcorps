class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new params[:user_session]
    if @user_session.save
      flash[:success] = 'You have been logged in.'
      redirect_to root_path
    else
      flash[:failure] = 'Invalid credentials.'
      render :action => :new
    end
  end
  
  def destroy
    current_session.destroy
    flash[:success] = 'You have been logged out.'
    redirect_to root_path
  end

end