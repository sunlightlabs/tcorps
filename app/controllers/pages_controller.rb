class PagesController < ApplicationController

  def index
    @users = User.all :order => 'created_at DESC', :limit => 5
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