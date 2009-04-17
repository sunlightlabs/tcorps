ActionController::Routing::Routes.draw do |map|

  map.resource :session
  map.resources :tasks
  
  map.complete_task 'tasks/complete', :controller => 'tasks', :action => 'complete'

  map.root :controller => 'campaigns', :action => 'index'
end