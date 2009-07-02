require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test '#index loads the most recent 5 users' do
    user = Factory :user
    User.expects(:by_points).returns User
    User.expects(:all).with(:limit => 5).returns [Factory(:user)]
    get :index
  end
  
  test '#index loads all active campaigns' do
    Campaign.expects(:active).returns Campaign
    get :index
    assert_response :success
    assert_template 'index'
  end
  
  test '#index loads all active campaigns relevant to the logged in user, if the user is logged in' do
    user = Factory :user
    
    Campaign.expects(:active_for).with(user).returns Campaign
    login user
    
    get :index
  end
  
  # every page should have these campaigns for the sidebar, but we'll just test it here
  test '#about loads the most recent 5 active campaigns for the sidebar' do
    Campaign.expects(:active).returns Campaign
    
    get :about
  end
  
  test '#about loads the most recent 5 active campaigns for the logged in user for the sidebar, if logged in' do
    user = Factory :user
    Campaign.expects(:active_for).with(user).returns Campaign
    
    login user
    get :about
  end

  test '#contact with post and all data sends contact form email' do
    name = 'name'
    email = 'email'
    message = 'message'
    ContactMailer.expects(:deliver_contact_form).with(name, email, message)
    
    post :contact, :name => name, :email => email, :message => message
    assert_redirected_to contact_path
    assert_not_nil flash[:success]
  end
  
  test '#contact with post requires name' do
    name = 'name'
    email = 'email'
    message = 'message'
    ContactMailer.expects(:deliver_contact_form).never
    
    post :contact, :email => email, :message => message
    assert_response :success
    assert_template 'contact'
    assert_not_nil assigns(:error_messages)
  end
  
  test '#contact with post requires email' do
    name = 'name'
    email = 'email'
    message = 'message'
    ContactMailer.expects(:deliver_contact_form).never
    
    post :contact, :name => name, :message => message
    assert_response :success
    assert_template 'contact'
    assert_not_nil assigns(:error_messages)
  end
  
  test '#contact with post requires message' do
    name = 'name'
    email = 'email'
    message = 'message'
    ContactMailer.expects(:deliver_contact_form).never
    
    post :contact, :name => name, :email => email
    assert_response :success
    assert_template 'contact'
    assert_not_nil assigns(:error_messages)
  end
  
  test 'page routes' do
    [:about, :contact].each do |page|
      assert_routing "/#{page}", :controller => 'pages', :action => page.to_s
    end
    assert_routing '/', :controller => 'pages', :action => 'index'
  end
end
