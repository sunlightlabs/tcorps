class User < ActiveRecord::Base
  has_many :tasks
  has_many :campaigns, :foreign_key => :creator_id
  
  has_attached_file :avatar,
    :styles => {:normal => '64x64#'},
    :default_url => "/images/:silhouette"
  
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
  
  # randomize the default silhouette between male and female
  Paperclip::Attachment.interpolations[:silhouette] = proc do |attachment, style|
    "avatar_#{[:female, :male][rand 2]}.jpg"
  end
  
end