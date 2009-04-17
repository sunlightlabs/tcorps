require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  
  test '#create should create a new valid task' do
    
  end
  
  test '#create should redirect the user to #show' do
  
  end
  
  test '#create should fail with no campaign given' do
  
  end
  
  test '#create should require the user to be logged in' do
  
  end
  
  test '#show should render successfully' do
    
  end
  
  test '#show should require login' do
    
  end
  
  test '#complete with a valid task key updates the task to mark it as complete' do
    task = Factory :task
    assert !task.complete?
    post :complete, :task_key => task.key
    assert_response :success
    assert task.reload.complete?
  end
  
  test '#complete with an invalid task key returns a 404' do
    task = Factory :task
    assert !task.complete?
    post :complete, :task_key => task.key.succ
    assert_response :not_found
    assert !task.reload.complete?
  end
  
  test '#complete with no task key returns a 500' do
    post :complete
    assert_response :bad_request
  end
  
  test '#complete with a get returns 500' do
    task = Factory :task
    assert !task.complete?
    get :complete, :task_key => task.key
    assert_response :method_not_allowed
    assert !task.reload.complete?
  end
  
  test '#complete route' do
    assert_routing({:method => :post, :path => '/tasks/complete'}, {:controller => 'tasks', :action => 'complete'})
  end
end