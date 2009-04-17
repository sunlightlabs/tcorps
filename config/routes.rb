ActionController::Routing::Routes.draw do |map|

  map.resource :session
  map.resouces :tasks
  
  map.complete_task 'tasks/complete', :controller => 'tasks', :action => 'complete'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end