ActionController::Routing::Routes.draw do |map|

  map.resource :user_session
  map.resources :users
  map.resources :tasks
  
  map.complete_task '/tasks/complete', :controller => 'tasks', :action => 'complete'
  
  map.register '/register', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.root :controller => 'campaigns', :action => 'index'
end