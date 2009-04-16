ActionController::Routing::Routes.draw do |map|

  map.resource :session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
