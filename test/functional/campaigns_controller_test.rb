require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test '#index renders successfully' do
    get :index
    assert_response :success
  end
end