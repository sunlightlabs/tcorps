ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require 'authlogic/test_case'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  def login(user)
    UserSession.create user
  end
  
  def logout
    if UserSession.find
      UserSession.find.destroy
    end
  end
  
  def assert_layout(layout)
    assert_equal layout.to_s, @response.layout.split('/').last
  end
end