require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  
#   test '#index loads the top 5 campaigns for the sidebar' do
#     assert false
#   end
  
  test 'page routes' do
    [:about, :contact].each do |page|
      assert_routing "/#{page}", :controller => 'pages', :action => page.to_s
    end
    assert_routing '/', :controller => 'pages', :action => 'index'
  end
end
