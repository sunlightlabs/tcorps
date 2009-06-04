class Admin::CampaignsController < ApplicationController
  layout 'admin'
  
  skip_before_filter :load_sidebar
  before_filter :require_login
  before_filter :require_manager
  
  before_filter :load_campaign, :only => [:edit, :update, :destroy]

  def index
    @campaigns = current_user.campaigns
  end
  
  def edit
  end
  
  def update
    if @campaign.update_attributes params[:campaign]
      flash[:success] = 'Your campaign has been updated.'
      redirect_to admin_campaigns_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @campaign.destroy
    flash[:success] = 'Your campaign has been deleted.'
    redirect_to admin_campaigns_path
  end
  
  protected
  
  def load_campaign
    unless @campaign = Campaign.find_by_id(params[:id]) and @campaign.creator == current_user
      redirect_to root_path and return false
    end
  end
  
end