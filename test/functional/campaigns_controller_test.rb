require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test '#show loads a campaign' do
    campaign = Factory :campaign
    
    get :show, :id => campaign.id
    assert_template 'show'
    assert_equal assigns(:campaign), campaign
  end
  
  test '#show does not require login' do
    campaign = Factory :campaign
    
    get :show, :id => campaign.id
    assert_response :success
  end
  
  test '#show does not mind a login' do
    campaign = Factory :campaign
    login campaign.organization.user
    
    get :show, :id => campaign.id
    assert_response :success
  end
  
  test '#show gives a 404 with an invalid campaign id' do
    campaign = Factory :campaign
    assert !Campaign.exists?(campaign.id.succ)
    
    get :show, :id => campaign.id.succ
    assert_response :not_found
  end
  
end