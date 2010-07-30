require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  test "the truth" do
     get :index
     assert_response :success
     assert_not_nil assigns(:items)
  end
  
end
