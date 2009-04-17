require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test 'inherits points from campaign on creation' do
    task = Factory.build :task
    assert_nil task.points
    task.save
    assert_equal task.campaign.points, task.points
  end
  
  test '#complete? hinges on completed_at' do
    assert !Factory(:task).complete?
    assert Factory(:completed_task).complete?
    
    task = Factory :task
    task.update_attribute :completed_at, Time.now
    assert task.complete?
  end
end