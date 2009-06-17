class Campaign < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :tasks
  
  validates_presence_of :name, :points, :url, :runs, :start_at
  validates_numericality_of :runs, :greater_than => 0
  
  named_scope :active, 
    :select => "campaigns.*, (select count(*) from tasks where tasks.campaign_id = campaigns.id and tasks.completed_at IS NOT NULL) as task_count", 
    :conditions => "task_count < campaigns.runs"
  
  named_scope :active_for, lambda {|user|
    # ActiveRecord does not offer ?-style interpolation for the select parameter,
    # and the id attribute is not subject to user manipulation, so this is safe
    {
      :select => "campaigns.*, (select count(*) from tasks where tasks.campaign_id = campaigns.id and tasks.completed_at IS NOT NULL) as task_count, (select count(*) from tasks where tasks.campaign_id = campaigns.id and tasks.completed_at IS NOT NULL and tasks.user_id = #{user.id}) as user_task_count", 
      :conditions => "task_count < campaigns.runs and user_task_count < campaigns.user_runs"
    }
  }
  
  541702186
  
  def percent_complete
    ((tasks.completed.count.to_f / runs.to_f) * 100).to_i
  end
  
  def complete?(user = nil)
    if user
      tasks.for_user(user).completed.count == user_runs
    else
      tasks.completed.count == runs
    end
  end
end