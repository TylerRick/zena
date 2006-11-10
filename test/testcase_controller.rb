class ControllerTestCase < Test::Unit::TestCase
  
  # initialize session by making a first call
  def init_controller
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller.instance_eval { @session = {}; @params = {}; @url = ActionController::UrlRewriter.new( @request, {} ) }
  end
  
  # login for functional testing
  def login(visitor=:ant)
    @controller_bak = @controller
    @controller = LoginController.new
    post 'login', :user=>{:login=>visitor.to_s, :password=>visitor.to_s}
    @controller = @controller_bak
  end
  
  def logout
    @controller_bak = @controller
    @controller = LoginController.new
    post 'logout'
    @controller = @controller_bak
  end
  
  def test_dummy
  end
end