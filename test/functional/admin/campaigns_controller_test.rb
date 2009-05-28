require 'test_helper'

class Admin::CampaignsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test '#index loads the campaigns for that user' do
    user = Factory :manager
    campaign1 = Factory :campaign, :creator => user
    campaign2 = Factory :campaign, :creator => user
    assert user.campaigns.any?
    
    login user
    
    get :index
    assert_response :success
    assert_layout 'admin'
    assert_template 'index'
    
    assert_equal assigns(:campaigns), user.campaigns
  end
  
  test '#index allows administrators as well' do
    login Factory(:admin)
    get :index
    assert_response :success
  end
  
  test '#index requires login' do
    get :index
    assert_redirected_to root_path
  end
  
  test '#index requires login as at least a manager' do
    login Factory(:user)
    get :index
    assert_redirected_to root_path
  end
  
end