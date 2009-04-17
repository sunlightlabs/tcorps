require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test '#total_points counts tasks from all campaigns' do
    user = Factory :user
    assert_equal 0, user.total_points
    
    campaign_one = Factory :campaign, :points => 1
    campaign_two = Factory :campaign, :points => 2
    campaign_three = Factory :campaign, :points => 4
    Factory :completed_task, :campaign => campaign_one, :user => user
    Factory :completed_task, :campaign => campaign_two, :user => user
    Factory :completed_task, :campaign => campaign_three, :user => user
    
    assert_equal 7, user.total_points
  end
  
  test '#total_points counts only completed tasks' do
    user = Factory :user
    assert_equal 0, user.total_points
    
    campaign_one = Factory :campaign, :points => 1
    campaign_two = Factory :campaign, :points => 2
    campaign_three = Factory :campaign, :points => 4
    Factory :completed_task, :campaign => campaign_one, :user => user
    Factory :task, :campaign => campaign_two, :user => user
    Factory :completed_task, :campaign => campaign_three, :user => user
    
    assert_equal 5, user.total_points
  end
  
  test '#campaign_points counts tasks from one campaign' do
    user = Factory :user    
    
    campaign_one = Factory :campaign, :points => 1
    campaign_two = Factory :campaign, :points => 2
    campaign_three = Factory :campaign, :points => 4
    
    assert_equal 0, user.campaign_points(campaign_one)
    assert_equal 0, user.campaign_points(campaign_two)
    assert_equal 0, user.campaign_points(campaign_three)
    
    Factory :completed_task, :campaign => campaign_one, :user => user
    Factory :completed_task, :campaign => campaign_two, :user => user
    Factory :completed_task, :campaign => campaign_three, :user => user
    
    assert_equal 1, user.campaign_points(campaign_one)
    assert_equal 2, user.campaign_points(campaign_two)
    assert_equal 4, user.campaign_points(campaign_three)
  end
  
  test '#campaign_points counts only completed tasks' do
    user = Factory :user    
    campaign = Factory :campaign, :points => 1
    
    assert_equal 0, user.campaign_points(campaign)
    
    Factory :completed_task, :campaign => campaign, :user => user
    Factory :completed_task, :campaign => campaign, :user => user
    Factory :task, :campaign => campaign, :user => user
    
    assert_equal 2, user.campaign_points(campaign)
  end
  
end