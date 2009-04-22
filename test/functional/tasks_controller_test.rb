require 'test_helper'

class TasksControllerTest < ActionController::TestCase

  setup :activate_authlogic

  test '#create should create a new valid task' do
    count = Task.count
    
    campaign = Factory :campaign
    login campaign.organization.user
    
    post :create, :campaign_id => campaign.id
    assert_not_nil assigns(:task)
    assert_redirected_to task_path(assigns(:task))
    
    assert_equal count + 1, Task.count
  end
  
  test '#create should fail with no campaign given' do
    count = Task.count
    
    campaign = Factory :campaign
    login campaign.organization.user
    post :create
    assert_response :not_found
    
    assert_equal count, Task.count
  end
  
  test '#create should require the user to be logged in' do
    count = Task.count
    campaign = Factory :campaign
    
    post :create, :campaign_id => campaign.id
    assert_redirected_to root_path
    
    assert_equal count, Task.count
  end
  
  test '#show should render successfully' do
    task = Factory :task
    login task.user
    
    get :show, :id => task
    assert_equal task, assigns(:task)
    assert_response :success
  end
  
  test '#show for a missing task should return a 404' do
    task = Factory :task
    login task.user
    get :show, :id => task.id.succ
    assert_response :not_found
  end
  
  test '#show should require login' do
    task = Factory :task
    get :show, :id => task
    assert_redirected_to root_path
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