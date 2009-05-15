class Campaign < ActiveRecord::Base
  belongs_to :organization
  has_many :tasks
  
  validates_presence_of :name, :keyword, :points, :url, :runs
  validates_numericality_of :runs, :greater_than => 0
  validates_uniqueness_of :keyword
  
  named_scope :active, :select => "campaigns.*, (select count(*) from tasks where tasks.campaign_id = campaigns.id and tasks.completed_at IS NOT NULL) as task_count", :conditions => "task_count < campaigns.runs"
  
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