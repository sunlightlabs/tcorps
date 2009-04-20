class User < ActiveRecord::Base
  acts_as_authentic

  belongs_to :organization
  has_many :tasks
  
  def total_points
    tasks.sum :points, :conditions => 'completed_at is not null'
  end
  
  def campaign_points(campaign)
    tasks.sum :points, :conditions => ['completed_at is not null and campaign_id = ?', campaign.id]
  end
  
end