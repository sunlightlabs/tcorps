require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  
  # every page should have these campaigns for the sidebar, but we'll just test it here
#   test '#index loads the most recent 5 incomplete campaigns for the sidebar' do
#     assert false
#   end
  
  test 'page routes' do
    [:about, :contact].each do |page|
      assert_routing "/#{page}", :controller => 'pages', :action => page.to_s
    end
    assert_routing '/', :controller => 'pages', :action => 'index'
  end
end
