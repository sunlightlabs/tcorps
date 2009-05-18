class User < ActiveRecord::Base

  belongs_to :organization
  has_many :tasks
  
  has_attached_file :avatar,
    :styles => {:normal => '64x64#'}
  
  acts_as_authentic do |c|
    c.session_ids = [] # this disables authlogic's autologin when a user is created
  end
  
  def total_points
    tasks.sum :points, :conditions => 'completed_at is not null'
  end
  
  def campaign_points(campaign)
    tasks.sum :points, :conditions => ['completed_at is not null and campaign_id = ?', campaign.id]
  end
  
end