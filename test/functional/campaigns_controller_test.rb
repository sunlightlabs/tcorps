require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test '#index loads all active campaigns' do
    campaign = Factory :campaign
    active = Campaign.active
    assert active.include?(campaign)
    
    Campaign.expects(:active).times(2).returns(active)
    get :index
    assert_response :success
    assert_template 'index'
    
    assert assigns(:campaigns).include?(campaign)
  end

  test '#show loads a campaign' do
    campaign = Factory :campaign
    
    get :show, :id => campaign.id
    assert_response :success
    assert_template 'show'
    assert_equal assigns(:campaign), campaign
  end
  
  test '#show gives a 404 with an invalid campaign id' do
    campaign = Factory :campaign
    assert !Campaign.exists?(campaign.id.succ)
    
    get :show, :id => campaign.id.succ
    assert_response :not_found
  end
  
end