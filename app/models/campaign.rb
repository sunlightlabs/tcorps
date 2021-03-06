class Campaign < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :tasks
  
  validates_presence_of :name, :points, :url, :runs, :start_at
  validates_numericality_of :runs, :greater_than => 0
  
  named_scope :active, 
    :select => "campaigns.*", 
    :conditions => ["start_at < ? and (select count(*) from tasks where tasks.campaign_id = campaigns.id and tasks.completed_at IS NOT NULL) < campaigns.runs", Time.now]
  
  named_scope :active_for, lambda {|user|
    # ActiveRecord does not offer ?-style interpolation for the select parameter,
    # and the id attribute is not subject to user manipulation, so this is safe
    {
      :select => "campaigns.*", 
      :conditions => ["start_at < ? and (select count(*) from tasks where tasks.campaign_id = campaigns.id and tasks.completed_at IS NOT NULL) < campaigns.runs and (campaigns.user_runs IS NULL OR campaigns.user_runs = 0 OR (select count(*) from tasks where tasks.campaign_id = campaigns.id and tasks.completed_at IS NOT NULL and tasks.user_id = ?) < campaigns.user_runs)", Time.now, user.id]
    }
  }
  
  def self.percent_complete
    tasks_complete = Task.completed.count
    runs = Campaign.sum :runs
    return 0 if tasks_complete == 0 or runs == 0
    ((Task.completed.count.to_f / Campaign.sum(:runs).to_f) * 100).to_i
  end
  
  def percent_complete
    # since runs must be greater than 0 in the validations, 
    # NaN and divide by zero errors are not an issue
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