require 'test_helper'

class TasksHelperTest < ActionView::TestCase

  test 'task URL generator' do
    campaign = Factory :campaign, :points => 5
    user = Factory :user
    completed_task = Factory :completed_task, :campaign => campaign, :user => user
    assert_equal campaign.points, user.campaign_points(campaign)
    
    task = Factory :task, :key => 'example_key', :user => user, :campaign => campaign
    url = task_url task, user
    
    assert_match /username=#{user.login}/, url
    assert_match /task_key=#{task.key}/, url
    assert_match /points=#{user.campaign_points(campaign)}/, url
    assert_match campaign.url, url
  end

end