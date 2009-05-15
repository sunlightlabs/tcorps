class TasksController < ApplicationController
  
  before_filter :require_login, :except => :complete
  before_filter :load_task, :only => :show
  before_filter :load_campaign, :only => :create
  
  def complete
    head :method_not_allowed and return false unless request.post?
   
    head :not_found and return false unless @task = Task.find_by_key(params[:task_key])
    
    @task.update_attribute :completed_at, Time.now
    head :ok
  end
  
  def show
    render :action => :show, :layout => 'task'
  end
  
  def create
    @task = @campaign.tasks.new :user => current_user
    if @task.save
      redirect_to task_path(@task)
    else
      flash[:failure] = "You can't do any more tasks from this campaign."
      redirect_to root_path
    end    
  end
  
  private
  
  def load_task
    head :not_found and return false unless @task = Task.find_by_id(params[:id])
  end
  
  def load_campaign
    head :not_found and return false unless @campaign = Campaign.find_by_id(params[:campaign_id])
  end
  
end