require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test 'inherits points from campaign on creation' do
    task = Factory.build :task
    assert_nil task.points
    task.save
    assert_equal task.campaign.points, task.points
  end
  
  test 'generates a random 32-char hex key on creation' do
    task = Factory.build :task
    assert_nil task.key
    task.save
    assert_not_nil task.key
    assert task.key.is_a?(String)
    assert_equal 32, task.key.size
    
    # impossible
    # assert_random task.key
  end
  
  test 'does not modify the hex key on update' do
    task = Factory :task
    key = task.key
    task.save
    assert_equal key, task.reload.key
  end
  
  test '#complete? hinges on completed_at' do
    assert !Factory(:task).complete?
    assert Factory(:completed_task).complete?
    
    task = Factory :task
    task.update_attribute :completed_at, Time.now
    assert task.complete?
  end
  
  test 'named scope of #completed finds completed tasks' do
    task1 = Factory :task
    task2 = Factory :task
    completed_task1 = Factory :completed_task
    completed_task2 = Factory :completed_task
    completed_task3 = Factory :completed_task
    
    completed = Task.completed.all
    assert !completed.include?(task1)
    assert !completed.include?(task2)
    assert completed.include?(completed_task1)
    assert completed.include?(completed_task2)
    assert completed.include?(completed_task3)
    
    completed.each {|t| assert t.complete?}
  end
end