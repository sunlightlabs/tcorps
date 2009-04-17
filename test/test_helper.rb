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
    UserSession.find.destroy if UserSession.find
  end
end