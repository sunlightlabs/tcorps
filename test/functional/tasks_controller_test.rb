require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test '#create should create a new valid task' do
    count = Task.count
    
    campaign = Factory :campaign
    user = campaign.creator
    login user
    
    post :create, :campaign_id => campaign.id
    assert_not_nil assigns(:task)
    assert_equal assigns(:task).user, user
    assert_redirected_to task_path(assigns(:task))
    
    assert_equal count + 1, Task.count
  end
  
  test '#create should fail with no campaign given' do
    count = Task.count
    
    campaign = Factory :campaign
    login campaign.creator
    post :create
    assert_response :not_found
    
    assert_equal count, Task.count
  end
  
  test '#create should require login' do
    count = Task.count
    campaign = Factory :campaign
    logout
    
    post :create, :campaign_id => campaign.id
    assert_redirected_to register_path
    
    assert_equal count, Task.count
  end
  
  test '#create should fail if the campaign has hit its maximum runs' do
    campaign = Factory :campaign, :runs => 1, :user_runs => 2
    task = Factory :completed_task, :campaign => campaign
    count = Task.count
    assert campaign.complete?
    
    login campaign.creator
    post :create, :campaign_id => campaign.id
    assert_redirected_to root_path
    assert_not_nil flash[:failure]
    
    assert_equal count, Task.count
  end
  
  test '#create should fail if the campaign has hits its maximum runs for that user' do
    user = Factory :user
    campaign = Factory :campaign, :runs => 2, :user_runs => 1
    task = Factory :completed_task, :campaign => campaign, :user => campaign.creator
    count = Task.count
    assert !campaign.complete?
    
    login campaign.creator
    post :create, :campaign_id => campaign.id
    assert_redirected_to root_path
    assert_not_nil flash[:failure]
    
    assert_equal count, Task.count
  end
  
  test '#show should render successfully' do
    task = Factory :task
    login task.user
    
    get :show, :id => task
    assert_equal task, assigns(:task)
    assert_response :success
  end
  
  test '#show should use the task layout and render an iframe with the task url' do
    task = Factory :task
    login task.user
    
    get :show, :id => task
    assert_layout :task
    assert_select 'iframe'
    assert_match task.campaign.url, @response.body
    assert_match /username=#{task.user.login}/, @response.body
    assert_match /task_key=#{task.key}/, @response.body
    assert_match /points=#{task.user.campaign_points(task.campaign)}/, @response.body
  end
  
  test '#show for a completed task should redirect out' do
    task = Factory :completed_task
    login task.user
    get :show, :id => task
    assert_redirected_to campaign_path(task.campaign)
  end
  
  test '#show for a missing task should return a 404' do
    task = Factory :task
    login task.user
    get :show, :id => task.id.succ
    assert_response :not_found
  end
  
  test '#show should require login' do
    task = Factory :task
    logout
    
    get :show, :id => task
    assert_redirected_to register_path
  end
  
  test '#complete with a valid task key updates the task to mark it as complete' do
    task = Factory :task
    assert !task.complete?
    count = Task.count
    
    post :complete, :task_key => task.key
    
    assert_response :success
    assert @response.body.strip.empty?
    
    assert task.reload.complete?
    assert_equal count, Task.count
  end
  
  test '#complete with new_task set to 1 should return a response body with the new valid task URL' do
    task = Factory :task
    assert !task.complete?
    post :complete, :task_key => task.key, :new_task => 1
    
    assert_response :success
    assert !@response.body.strip.empty?
    assert_match task.campaign.url, @response.body
    
    assert task.reload.complete?
    
  end
  
  test '#complete with new_task set to 1 should create a new task' do
    task = Factory :task
    assert !task.complete?
    count = Task.count
    
    post :complete, :task_key => task.key, :new_task => 1
    assert_response :success
    
    assert_equal count + 1, Task.count
    new_task = Task.all(:order => 'id desc').first
    assert_match /username=#{new_task.user.login}/, @response.body
    assert_match /task_key=#{new_task.key}/, @response.body
    assert_match /points=#{new_task.user.campaign_points(new_task.campaign)}/, @response.body
  end
  
  test '#complete with a valid task key increases the amount of points a user has' do
    user = Factory :user
    task = Factory :task, :user => user
    total_points = user.total_points
    campaign_points = user.campaign_points(task.campaign)
    
    post :complete, :task_key => task.key
    
    assert_equal total_points + task.points, user.total_points
    assert_equal campaign_points + task.points, user.campaign_points(task.campaign)
  end
  
  test '#complete with a valid task key records the time it took a user to complete the task' do
    user = Factory :user
    task = Factory :task, :user => user
    ActiveRecord::Base.connection.execute "update tasks set created_at = '#{2.days.ago.to_s :db}' where id= #{task.id}"
    assert task.reload.created_at <= 2.days.ago
    assert_nil task.elapsed_seconds
    
    post :complete, :task_key => task.key
    
    assert_not_nil task.reload.elapsed_seconds
    assert task.reload.elapsed_seconds >= 2.days.to_i
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