class PagesController < ApplicationController

  skip_before_filter :load_sidebar, :only => :index

  def index
    @users = User.by_points.all :limit => 5
    @campaigns = (logged_in? ? Campaign.active_for(current_user) : Campaign.active).all :order => 'created_at DESC'
  end

  def contact
    if request.post?
      if params[:name].blank? or params[:email].blank? or params[:message].blank?
        @error_messages = 'Please fill out all fields.'
      else
        ContactMailer.deliver_contact_form params[:name], params[:email], params[:message]
        flash[:success] = 'Your message has been sent.'
        redirect_to contact_path
      end
    end
  end

end