class TasksController < ApplicationController
  
  before_filter :require_login, :except => :complete
  before_filter :load_task, :only => :show
  before_filter :load_campaign, :only => :create
  
  skip_before_filter :verify_authenticity_token, :only => :complete
  
  def complete
    head :method_not_allowed and return false unless request.post?
    head :not_found and return false unless @task = Task.find_by_key(params[:task_key])
    
    now = Time.now
    elapsed = Time.now - @task.created_at
    @task.update_attributes :completed_at => now, :elapsed_seconds => elapsed
    
    if params[:new_task] and params[:new_task].to_i == 1
      task = @task.campaign.tasks.create! :user => @task.user
      render :text => remote_task_url(task, @task.user)
    else
      head :ok
    end
  end
  
  def show
    if @task.complete?
      redirect_to campaign_path(@task.campaign)
    else
      render :action => :show, :layout => 'task'
    end
  end
  
  def create
    @task = @campaign.tasks.new :user => current_user
    if @task.save
      redirect_to task_path(@task)
    else
      flash[:failure] = "You've already done more than enough for this campaign.  Please try your hand at another of the campaigns below."
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