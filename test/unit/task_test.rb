require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test 'inherits points from campaign on creation' do
    task = Factory.build :task
    assert_nil task.points
    task.save
    assert_equal task.campaign.points, task.points
  end
end