require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup :activate_authlogic

  test '#new renders successfully' do
    logout
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end
  
  test '#create with valid user credentials creates a new user and logs them in' do
    logout
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
    logout
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
end