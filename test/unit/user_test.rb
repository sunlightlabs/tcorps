require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test '#by_points includes points as an attribute on user and sorts on this attribute' do
    user1 = Factory :user
    user2 = Factory :user
    user3 = Factory :user
    
    campaign_one = Factory :campaign, :creator => user1, :points => 1
    campaign_two = Factory :campaign, :creator => user2, :points => 2
    campaign_three = Factory :campaign, :creator => user3, :points => 4
    campaign_four = Factory :campaign, :creator => user3, :points => 8
    Factory :completed_task, :campaign => campaign_one, :user => user3
    Factory :completed_task, :campaign => campaign_two, :user => user1
    Factory :completed_task, :campaign => campaign_three, :user => user2
    Factory :completed_task, :campaign => campaign_four, :user => user2
    
    assert_equal [user2, user1, user3], User.by_points.all
    assert_nothing_raised do
      assert_equal 12, User.by_points.first.sum_points.to_i
    end
  end
  
  test '#leaders only returns people who are at least level 1' do
    minimum = LEVELS.keys.sort.first
    
    user1 = Factory :user
    user2 = Factory :user
    user3 = Factory :user
    
    campaign_one = Factory :campaign, :creator => user1, :points => minimum - 1
    campaign_two = Factory :campaign, :creator => user1, :points => minimum
    campaign_three = Factory :campaign, :creator => user1, :points => minimum + 1
    Factory :completed_task, :campaign => campaign_one, :user => user1
    Factory :completed_task, :campaign => campaign_two, :user => user2
    Factory :completed_task, :campaign => campaign_three, :user => user3
    
    assert_equal [user3, user2], User.by_points.leaders.all
  end
  
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
  
  test '#manager? depends on presence of organization name' do
    assert Factory(:user, :organization_name => 'any name').manager?
    assert !Factory(:user, :organization_name => nil).manager?
    assert !Factory(:user, :admin => true, :organization_name => nil).manager?
  end
  
end