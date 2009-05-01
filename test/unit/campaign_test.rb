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
  
#   test '#incomplete named scope limits search to campaigns who have fewer completed tasks than the # of specified runs' do
#     assert false
#   end
  
end