class CampaignsController < ApplicationController
  
  before_filter :load_campaign, :only => :show
  
  def show
  end
  
  def index
    respond_to do |format|
      format.html {
        @campaigns = (logged_in? ? Campaign.active_for(current_user) : Campaign.active).all :order => 'created_at DESC'
      }
      format.xml {
        @campaigns = Campaign.active.all :order => 'created_at DESC'
      }
    end
  end
  
  private
  
  def load_campaign
    redirect_to campaigns_path and return false unless @campaign = Campaign.find_by_id(params[:id])
  end
  
end