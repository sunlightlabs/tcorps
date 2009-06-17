class User < ActiveRecord::Base
  has_many :tasks
  has_many :campaigns, :foreign_key => :creator_id
  
  has_attached_file :avatar,
    :styles => {:normal => '64x64#'},
    :default_url => "/images/:silhouette"
  
  named_scope :by_points, :select => 'users.*, (select sum(tasks.points) as sum_points from tasks where completed_at is not null and tasks.user_id = users.id) as sum_points', :order => 'sum_points desc'
  named_scope :leaders, lambda {
    {:conditions => ['sum_points >= ?', LEVELS.keys.sort.first]}
  }
  
  acts_as_authentic do |c|
    c.session_ids = [] # this disables authlogic's autologin when a user is created
  end
  
  def total_points
    tasks.sum :points, :conditions => 'completed_at is not null'
  end
  
  def campaign_points(campaign)
    tasks.sum :points, :conditions => ['completed_at is not null and campaign_id = ?', campaign.id]
  end
  
  def manager?
    !organization_name.blank?
  end
  
  def level
    points = respond_to?(:sum_points) ? sum_points.to_i : total_points
    levels = LEVELS.keys.sort
    
    level = 0
    levels.each_with_index do |minimum, i|
      level = i + 1 if points >= minimum
    end
    level
  end
  
  Paperclip.interpolates :silhouette do |attachment, style|
    "avatar_#{[:female, :male][rand 2]}.jpg"
  end
  
end