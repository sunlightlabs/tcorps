class CampaignsController < ApplicationController
  
  before_filter :load_campaign, :only => :show
  
  def show
  end
  
  def index
    @campaigns = Campaign.active.all :order => 'created_at DESC'
  end
  
  private
  
  def load_campaign
    head :not_found and return false unless @campaign = Campaign.find_by_id(params[:id])
  end
  
end