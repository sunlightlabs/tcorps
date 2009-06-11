require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  
  test '#percent_complete measures percent of completed tasks' do  
    campaign = Factory :campaign, :runs => 5
    task1 = Factory :task, :campaign => campaign
    task2 = Factory :task, :campaign => campaign
    task3 = Factory :task, :campaign => campaign
    task4 = Factory :task, :campaign => campaign
    task5 = Factory :task, :campaign => campaign
    
    assert_equal 0, campaign.percent_complete
    task1.update_attribute :completed_at, Time.now
    assert_equal 20, campaign.percent_complete
    task2.update_attribute :completed_at, Time.now
    assert_equal 40, campaign.percent_complete
    task3.update_attribute :completed_at, Time.now
    assert_equal 60, campaign.percent_complete
    task4.update_attribute :completed_at, Time.now
    assert_equal 80, campaign.percent_complete
    task5.update_attribute :completed_at, Time.now
    assert_equal 100, campaign.percent_complete
  end
  
  test '#active named scope limits search to campaigns who have fewer completed tasks than the # of specified runs' do
    campaign1 = Factory :campaign, :runs => 2
    campaign2 = Factory :campaign, :runs => 2
    campaign3 = Factory :campaign, :runs => 2
    
    Factory :task, :campaign => campaign1
    Factory :task, :campaign => campaign1
    Factory :completed_task, :campaign => campaign2
    Factory :completed_task, :campaign => campaign3
    Factory :completed_task, :campaign => campaign3
    
    assert Campaign.active.include?(campaign1)
    assert Campaign.active.include?(campaign2)
    assert !Campaign.active.include?(campaign3)
  end
  
  test '#complete? indicates whether the maximum runs have been met' do
    campaign1 = Factory :campaign, :runs => 2
    campaign2 = Factory :campaign, :runs => 2
    campaign3 = Factory :campaign, :runs => 2
    
    Factory :task, :campaign => campaign1
    Factory :task, :campaign => campaign1
    Factory :completed_task, :campaign => campaign2
    Factory :completed_task, :campaign => campaign3
    Factory :completed_task, :campaign => campaign3
    
    assert !campaign1.complete?
    assert !campaign2.complete?
    assert campaign3.complete?
  end
  
  test '#complete? with a user passed in indicates whether the maximum runs for that user have been met' do
    user1 = Factory :user
    user2 = Factory :user
    user3 = Factory :user
    
    campaign1 = Factory :campaign, :runs => 3, :user_runs => 1
    campaign2 = Factory :campaign, :runs => 3, :user_runs => 2
    campaign3 = Factory :campaign, :runs => 3, :user_runs => 3
    
    Factory :task, :campaign => campaign1, :user => user1
    Factory :completed_task, :campaign => campaign2, :user => user2
    Factory :completed_task, :campaign => campaign2, :user => user2
    Factory :completed_task, :campaign => campaign3, :user => user1
    Factory :completed_task, :campaign => campaign3, :user => user2
    Factory :completed_task, :campaign => campaign3, :user => user3
    
    assert !campaign1.complete?(user1)
    assert !campaign1.complete?(user2)
    assert !campaign1.complete?
    
    assert !campaign2.complete?(user1)
    assert campaign2.complete?(user2)
    assert !campaign2.complete?
    
    assert !campaign3.complete?(user1)
    assert !campaign3.complete?(user2)
    assert !campaign3.complete?(user3)
    assert campaign3.complete?
  end
  
  test '#complete? for a user will always return true if the user_runs field is blank' do
    user = Factory :user
    endless_campaign = Factory :campaign, :user_runs => nil
    
    Factory :completed_task, :user => user
    assert false
  end
  
end