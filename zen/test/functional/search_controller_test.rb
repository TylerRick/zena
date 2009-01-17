=begin
require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < ZenaTestController

  def setup
    super
    @controller = SearchController.new
    init_controller
  end
  
  def test_find_children_for_anon
    post 'find', :id=>nodes_id(:people), :search=>''
    assert_response :success
    assert_equal 2, assigns['results'].size
  end
  
  def test_find_children_for_ant
    login(:ant)
    post 'find', :id=>nodes_id(:people)
    assert_response :success
    assert_equal 3, assigns['results'].size
  end
    
  def test_find_with_attribute
    post 'find', :search=>'lake'
    assert_response :success
    assert_equal 2, assigns['results'].size
    assert_tag :p, :attributes=>{:class=>'result_id'}
  end
  
  def test_find_private
    login(:ant)
    post 'find', :search=>'ant'
    assert_response :success
    assert_equal 1, assigns['results'].size
    assert_equal 'ant', assigns['results'][0].name
    assert_tag :p, :attributes=>{:class=>'result_id'}
  end
  
  def test_do_not_find_private
    post 'find', :search=>'ant'
    assert_response :success
    assert_equal [], assigns['results']
  end
end
=end