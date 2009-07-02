require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test '#index loads all active campaigns' do
    Campaign.expects(:active).returns Campaign
    get :index
    assert_response :success
    assert_template 'index'
  end
  
  test '#index loads all active campaigns relevant to the logged in user, if the user is logged in' do
    user = Factory :user
    
    Campaign.expects(:active_for).with(user).returns Campaign
    login user
    
    get :index
  end
  
  test '#index.xml loads all active campaigns' do
    Campaign.expects(:active).returns Campaign
    get :index, :format => 'xml'
    assert_response :success
    assert_template 'index.xml'
  end

  test '#show loads a campaign' do
    campaign = Factory :campaign
    
    get :show, :id => campaign
    assert_response :success
    assert_template 'show'
    assert_equal assigns(:campaign), campaign
  end
  
  test '#show gives a 404 with an invalid campaign id' do
    campaign = Factory :campaign
    assert !Campaign.exists?(campaign.id.succ)
    
    get :show, :id => campaign.id.succ
    assert_redirected_to campaigns_path
  end
  
end