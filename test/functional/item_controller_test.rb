require File.dirname(__FILE__) + '/../test_helper'
require 'item_controller'

# Re-raise errors caught by the controller.
class ItemController; def rescue_action(e) raise e end; end

class ItemControllerTest < ControllerTestCase
  def setup
    @controller = ItemController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  
  def test_drive
    assert false, "test todo"
  end
end