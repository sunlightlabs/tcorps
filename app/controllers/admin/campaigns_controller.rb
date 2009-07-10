class Admin::CampaignsController < ApplicationController
  layout 'admin'
  skip_before_filter :load_sidebar
  
  before_filter :require_login
  before_filter :require_manager
  
  before_filter :load_campaign, :only => [:edit, :update, :confirm_destroy, :destroy]

  def index
    @campaigns = current_user.campaigns.all(:order => 'created_at DESC')
  end
  
  def new
    @campaign = current_user.campaigns.new :points => RECOMMENDED_CAMPAIGN_POINTS
  end
  
  def create
    @campaign = current_user.campaigns.new params[:campaign]
    if @campaign.save
      deliver_campaign_notifications @campaign
      flash[:success] = 'Campaign created.'
      redirect_to admin_campaigns_path
    else
      render :action => :new
    end
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
  
  def confirm_destroy
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
  
  def deliver_campaign_notifications(campaign)
    (User.campaign_subscribers.all - [campaign.creator]).each do |user|
      CampaignMailer.deliver_new_campaign(campaign, user)
    end 
  end
  
end