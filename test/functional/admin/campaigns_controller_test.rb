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
  
  test '#edit loads a campaign for editing' do
    user = Factory :manager
    campaign = Factory :campaign, :creator => user
    
    login user
    get :edit, :id => campaign
    assert_response :success
    assert_template 'edit'
    
    assert_equal campaign, assigns(:campaign)
  end
  
  test '#edit will not load campaigns owned by others' do
    user = Factory :manager
    campaign = Factory :campaign
    
    login user
    get :edit, :id => campaign
    assert_redirected_to root_path
  end
  
  test '#edit requires login' do    
    get :edit, :id => Factory(:campaign)
    assert_redirected_to root_path
  end
  
  test '#edit requires login as at least a manager' do
    user = Factory :user
    campaign = Factory :campaign, :creator => user
    
    login user
    get :edit, :id => campaign
    assert_redirected_to root_path
  end
  
  test '#update will update a campaign' do
    user = Factory :manager
    campaign = Factory :campaign, :creator => user
    new_name = campaign.name.succ
    
    login user
    put :update, :id => campaign, :campaign => {:name => new_name}
    assert_redirected_to admin_campaigns_path
    assert_not_nil flash[:success]
    assert_equal new_name, campaign.reload.name
  end
  
  test '#update renders with errors if the campaign is invalid' do
    user = Factory :manager
    campaign = Factory :campaign, :creator => user
    
    login user
    put :update, :id => campaign, :campaign => {:name => ''}
    assert_response :success
    assert assigns(:campaign).errors.any?
    
    assert_not_equal '', campaign.reload.name
  end
  
  test '#update will not update campaigns owned by others' do
    user = Factory :manager
    campaign = Factory :campaign
    new_name = campaign.name.succ
    
    login user
    put :update, :id => campaign, :campaign => {:name => new_name}
    assert_redirected_to root_path
    assert_nil flash[:success]
    assert_not_equal new_name, campaign.reload.name
  end
  
  test '#update requires login' do
    user = Factory :manager
    campaign = Factory :campaign, :creator => user
    new_name = campaign.name.succ
    
    put :update, :id => campaign, :campaign => {:name => new_name}
    assert_redirected_to root_path
    assert_nil flash[:success]
    assert_not_equal new_name, campaign.reload.name
  end
  
  test '#update requires login as at least a manager' do
    user = Factory :user
    campaign = Factory :campaign, :creator => user
    new_name = campaign.name.succ
    
    login user
    put :update, :id => campaign, :campaign => {:name => new_name}
    assert_redirected_to root_path
    assert_nil flash[:success]
    assert_not_equal new_name, campaign.reload.name
  end
  
  test '#destroy removes campaign' do
    user = Factory :manager
    campaign = Factory :campaign, :creator => user
    count = Campaign.count
    
    login user
    delete :destroy, :id => campaign
    assert_redirected_to admin_campaigns_path
    assert_not_nil flash[:success]
    
    assert_equal count - 1, Campaign.count
  end
  
  test '#destroy will not remove campaigns owned by others' do
    user = Factory :admin
    campaign = Factory :campaign
    count = Campaign.count
    
    login user
    delete :destroy, :id => campaign
    assert_redirected_to root_path
    assert_nil flash[:success]
    
    assert_equal count, Campaign.count
  end
  
  test '#destroy requires login' do
    campaign = Factory :campaign
    count = Campaign.count
    
    delete :destroy, :id => campaign
    assert_redirected_to root_path
    assert_nil flash[:success]
    
    assert_equal count, Campaign.count
  end
  
  test '#destroy requires login as at least a manager' do
    user = Factory :user
    campaign = Factory :campaign, :creator => user
    count = Campaign.count
    
    delete :destroy, :id => campaign
    assert_redirected_to root_path
    assert_nil flash[:success]
    
    assert_equal count, Campaign.count
  end
  
end