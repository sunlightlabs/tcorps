require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup :activate_authlogic

  test '#new renders successfully' do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end
  
  test '#create with valid user credentials creates a new user and logs them in' do
    user = Factory.build :user
    
    count = User.count
    assert_nil UserSession.find
    
    post :create, :user => {:login => user.login, :password => user.password, :password_confirmation => user.password_confirmation, :email => user.email}
    assert_redirected_to root_path
    assert_not_nil flash[:success]
    
    assert_equal count + 1, User.count
    assert_not_nil UserSession.find
    
    assert_equal user.login, UserSession.find.user.login
  end
  
  test '#create with invalid user credentials does not create a new user and logs no one in' do
    user = Factory.build :user
    
    count = User.count
    assert_nil UserSession.find
    
    post :create, :user => {:login => user.login, :password => user.password, :password_confirmation => user.password_confirmation.succ, :email => user.email}
    assert_response :success
    assert_template 'new'
    assert_nil flash[:success]
    
    assert_equal count, User.count
    assert_nil UserSession.find
  end
  
  test '#edit loads a user' do
    user = Factory :user
    login user
    
    get :edit, :id => user.id
    assert_response :success
    assert_template 'edit'
    assert_equal user, assigns(:user)
  end
  
  test '#edit can only load oneself' do
    user = Factory :user
    login Factory(:user)
    
    get :edit, :id => user.id
    assert_redirected_to root_path
    assert_not_nil flash[:failure]
  end
  
  test '#edit requires login' do
    user = Factory :user
    
    get :edit, :id => user.id
    assert_redirected_to root_path
  end
  
  test '#update updates a user' do
    user = Factory :user, :login => 'login1'
    login user
    
    put :update, :id => user.id, :user => {:login => 'login2'}
    assert_redirected_to edit_user_path(user)
    assert_not_nil flash[:success]
    assert_equal 'login2', user.reload.login
  end
  
  test '#update with invalid user data renders the edit form with errors' do
    user = Factory :user
    login user
    
    put :update, :id => user.id, :user => {:login => ''}
    assert_response :success
    assert_template 'edit'
    assert assigns(:user).errors.any?
    assert !user.reload.login.blank?
  end
  
  test '#update can only update onself' do
    user = Factory :user, :login => 'login1'
    login Factory(:user)
    
    put :update, :id => user.id, :user => {:login => 'login2'}
    assert_redirected_to root_path
    assert_nil flash[:success]
    assert_not_equal 'login2', user.reload.login
  end
  
  test '#update requires login' do
    user = Factory :user, :login => 'login1'
    
    put :update, :id => user.id, :user => {:login => 'login2'}
    assert_redirected_to root_path
    assert_nil flash[:success]
    assert_not_equal 'login2', user.reload.login
  end
  
  # clickpass
  test '#process_openid_registration with valid info will register and login a user' do
    count = User.count
    assert_nil UserSession.find
    
    openid = "http://openid.example.com"
    user = Factory.attributes_for :user
    get :process_openid_registration, {:clickpass_openid => openid, :email => user[:email], :nickname => user[:login]}, {:working_openid => openid}
    
    assert_not_nil flash[:success]
    assert_redirected_to root_path
    assert_equal count + 1, User.count
    assert_not_nil UserSession.find
  end
  
  test '#process_openid_registration with invalid info redirects back to Clickpass' do
    count = User.count
    assert_nil UserSession.find
    
    openid = "http://openid.example.com"
    user = Factory.attributes_for :user
    get :process_openid_registration, {:clickpass_openid => openid, :email => 'bademail', :nickname => user[:login]}, {:working_openid => openid}
    
    assert_nil flash[:success]
    assert_response :redirect
    assert_match CLICKPASS_BASE_URL, @response.redirected_to
    assert_equal count, User.count
    assert_nil UserSession.find
  end
  
  test '#process_openid_registration with a mismatched openid bails and redirects home' do
    count = User.count
    assert_nil UserSession.find
    
    openid = "http://openid.example.com"
    user = Factory.attributes_for :user
    get :process_openid_registration, {:clickpass_openid => openid, :email => user[:email], :nickname => user[:login]}, {:working_openid => openid.succ}
    
    assert_nil flash[:success]
    assert_redirected_to root_path
    assert_equal count, User.count
    assert_nil UserSession.find
  end
  
  test '#add_openid_to_user with valid login info updates an existing user and logs them in' do
    clickpass_url = "http://clickpass.example.com"
    openid = "http://openid.example.com/"
    user = Factory :user
    assert_not_equal openid, user.openid_identifier
    
    get :add_openid_to_user, {:clickpass_merge_callback_url => clickpass_url, :user_id => user.login, :password => 'test', :openid_url => openid}, {:working_openid => openid}
    assert_redirected_to root_path
    assert_not_nil flash[:success]
    
    assert_not_nil UserSession.find
    assert_equal openid, user.reload.openid_identifier
    assert_nil session[:working_openid]
  end
  
  test '#add_openid_to_user with bad login info tells clickpass' do
    clickpass_url = "http://clickpass.example.com"
    openid = "http://openid.example.com/"
    user = Factory :user
    assert_not_equal openid, user.openid_identifier
    
    get :add_openid_to_user, {:clickpass_merge_callback_url => clickpass_url, :user_id => user.login, :password => 'badpassword', :openid_url => openid}, {:working_openid => openid}
    
    assert_response :redirect
    assert_match clickpass_url, @response.redirected_to
    assert_match "userid_authenticated=false", @response.redirected_to
    assert_nil flash[:success]
    
    assert_nil UserSession.find
    assert_not_equal openid, user.reload.openid_identifier
    assert_equal openid, session[:working_openid]
  end
  
  test '#add_openid_to_user with a mismatched openid tells clickpass' do
    clickpass_url = "http://clickpass.example.com"
    openid = "http://openid.example.com/"
    user = Factory :user
    assert_not_equal openid, user.openid_identifier
    
    get :add_openid_to_user, {:clickpass_merge_callback_url => clickpass_url, :user_id => user.login, :password => 'test', :openid_url => openid}, {:working_openid => openid.succ}
    
    assert_response :redirect
    assert_match clickpass_url, @response.redirected_to
    assert_match "openid_authenticated=false", @response.redirected_to
    assert_nil flash[:success]
    
    assert_nil UserSession.find
    assert_not_equal openid, user.reload.openid_identifier
    assert_equal openid.succ, session[:working_openid]
  end
end