class CampaignsController < ApplicationController
  
  before_filter :load_campaign
  
  def show
  end
  
  private
  
  def load_campaign
    head :not_found and return false unless @campaign = Campaign.find_by_id(params[:id])
  end
  
end