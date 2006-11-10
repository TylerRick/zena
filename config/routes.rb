ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  
  map.login  'login' , :controller=>'login', :action=>'login'
  map.logout 'logout', :controller=>'login', :action=>'logout'

  
  ## map.connect 'z/brick/plug/:plug_name/*args', :controller=>'brick', :action=>'plug'
  ## map.connect 'z/translate/:keyword', :controller=>'translation', :action=>'translate'
  map.default 'z/:controller/:action/:id'
  ## 
  ## # is this used ?
  ## map.connect 'data/:extension/:version_id/:img_name', :controller=>'document', :action=>'img'
  ## 
  ## 
  map.not_found '404', :controller=>'main', :action=>'not_found'
  map.connect '', :controller => "main", :action=>'index'
  ## 
  map.user_home "#{AUTHENTICATED_PREFIX}/home", :controller=>'user', :action=>'home', :prefix=>"#{AUTHENTICATED_PREFIX}"
  ## 
  map.connect ':prefix', :controller => "main", :action=>'index', :prefix=>/^(#{AUTHENTICATED_PREFIX}|\w\w)$/
  ## 
 ###  find by path
  if ZENA_ENV[:monolingual]      
  ##   map.connect "#{AUTHENTICATED_PREFIX}/w/:action/:id", :controller=>'web', :id=>/\d+/, :prefix=>"#{AUTHENTICATED_PREFIX}"
  ##   map.connect 'w/:action/:id', :controller=>'web', :id=>/\d+/, :prefix=>ZENA_ENV[:default_lang]
  ##   
  ##   map.connect "#{AUTHENTICATED_PREFIX}/*path", :controller=>'main', :action=>'show', :prefix=>"#{AUTHENTICATED_PREFIX}"
    map.connect '*path', :controller=>'main', :action=>'show', :prefix=> ZENA_ENV[:default_lang]    
  else
  ##   map.connect ':prefix/w/:action/:id', :controller=>'web', :id=>/\d+/, :prefix=>/^(#{AUTHENTICATED_PREFIX}|\w\w)$/
    map.connect ':prefix/*path', :controller=>'main', :action=>'show', :prefix=>/^(#{AUTHENTICATED_PREFIX}|\w\w)$/
    map.connect '*path', :controller=>'main', :action=>'redirect'
  end
  ## 
  ## # Allow downloading Web Service WSDL as a file with an extension
  ## # instead of a file named 'wsdl'
  ## map.connect ':controller/service.wsdl', :action => 'wsdl'
  ## 
  ## # Install the default route as the lowest priority.
  ## map.connect ':controller/:action/:id'
end
=begin
ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  
end
=end