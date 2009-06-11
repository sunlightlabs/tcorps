require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  
  # every page should have these campaigns for the sidebar, but we'll just test it here
#   test '#index loads the most recent 5 active campaigns for the sidebar' do
#     assert false
#   end

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
