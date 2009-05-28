class Admin::CampaignsController < ApplicationController
  layout 'admin'
  
  skip_before_filter :load_sidebar
  before_filter :require_login
  before_filter :require_manager

  def index
    @campaigns = current_user.campaigns
  end
end