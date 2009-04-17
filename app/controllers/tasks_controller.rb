class TasksController < ApplicationController
  
  before_filter :load_task
  verify :method => :post, :only => :complete
  
  def complete
    @task.update_attribute :completed_at, Time.now
    head :ok
  end
  
  private
  
  def load_task
    head :method_not_allowed unless request.post?
    head :bad_request and return false if params[:task_key].blank?
    head :not_found and return false unless @task = Task.find_by_key(params[:task_key])
  end
  
end