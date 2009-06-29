require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  test '#create with valid credentials logs a user in' do
    user = Factory :user
    logout
    assert_nil UserSession.find
    
    post :create, :user_session => {:login => user.login, :password => 'test'}
    assert_redirected_to campaigns_path
    assert_not_nil flash[:success]
    
    assert_not_nil UserSession.find
    assert_equal user, UserSession.find.user
  end
  
  test '#create with invalid credentials logs no user in' do
    user = Factory :user
    logout
    assert_nil UserSession.find
    
    post :create, :user_session => {:login => user.login, :password => 'test'.succ}
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:error_message)
    
    assert_nil UserSession.find
  end
  
  test '#create from an interrupted request will redirect the user there instead' do
    user = Factory :user
    logout
    assert_nil UserSession.find
    
    post :create, {:user_session => {:login => user.login, :password => 'test'}}, {:goto => admin_path}
    assert_not_nil UserSession.find
    assert_redirected_to admin_path
  end
  
  test '#destroy logs a user out' do
    user = Factory :user
    login user
    assert_not_nil UserSession.find
    
    delete :destroy
    assert_redirected_to root_path
    assert_not_nil flash[:success]
    
    assert_nil UserSession.find
  end
  
  test '#destroy when no user is logged in still works' do
    logout
    
    delete :destroy
    assert_redirected_to root_path
    assert_nil flash[:success]
    
    assert_nil UserSession.find
  end
  
  test '#new renders a login page' do
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:user_session)
  end
end