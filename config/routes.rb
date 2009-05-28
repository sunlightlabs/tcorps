ActionController::Routing::Routes.draw do |map|

  map.resource :user_session
  map.resources :users
  map.resources :tasks
  map.resources :campaigns
    
  map.complete_task '/tasks/complete', :controller => 'tasks', :action => 'complete'
  
  map.namespace(:admin) do |admin|
    admin.resources :campaigns
  end
  map.admin '/admin', :controller => 'admin/campaigns', :action => 'index'
  
  map.register '/register', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.about '/about', :controller => 'pages', :action => 'about'
  map.contact '/contact', :controller => 'pages', :action => 'contact'
  
  # clickpass
  map.begin_openid_login '/clickpass/begin_openid_login', :controller => 'user_sessions', :action => 'begin_openid_login'
  map.complete_openid_login '/clickpass/complete_openid_login', :controller => 'user_sessions', :action => 'complete_openid_login'
  map.add_openid_to_user '/clickpass/add_openid_to_user', :controller => 'users', :action => 'add_openid_to_user'
  map.process_openid_registration '/clickpass/process_openid_registration', :controller => 'users', :action => 'process_openid_registration'
  
  map.root :controller => 'pages', :action => 'index'
end