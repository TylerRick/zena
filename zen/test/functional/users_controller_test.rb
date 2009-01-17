require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ZenaTestController
  
  def setup
    super
    @controller = UsersController.new
    init_controller
  end
  
  def test_update_preferences
    login(:lion)
    put 'update', 'id' => users_id(:lion), 'user'=>{'name'=>'Leo Verneyi', 'lang'=>'en', 'time_zone'=>'Africa/Algiers', 'first_name'=>'Panthera', 'login'=>'lion', 'email'=>'lion@zenadmin.info'}
    assert_response :success
    user = assigns['user']
    assert_equal 'Africa/Algiers', user[:time_zone]
  end
  
  def test_render_invalid_adminLayout
    login(:lion)
    Version.connection.execute "UPDATE #{Version.table_name} SET text = 'empty' WHERE id = #{versions_id(:Node_admin_layout_zafu_en)}"
    without_files('test.host/zafu') do
      get 'index'
      assert_response :success
      assert_match %r{Using default '\+adminLayout' template}, @response.body
      assert_no_match %r{empty}, @response.body
    end
  end
end