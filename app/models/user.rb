class User < ActiveRecord::Base
  attr_accessible :login, :email, :openid_identifier, :password, :password_confirmation, :avatar, :subscribe_campaigns, :subscribe_all

  has_many :tasks
  has_many :campaigns, :foreign_key => :creator_id
  
  has_attached_file :avatar,
    :styles => {:normal => '64x64#', :tiny => '24x24#'},
    :default_url => "/images/avatar_:gender_:style.jpg"
  
  named_scope :by_points, :select => 'users.*, (select sum(tasks.points) as sum_points from tasks where completed_at is not null and tasks.user_id = users.id) as sum_points', :order => 'sum_points desc'
  named_scope :leaders, lambda {
    {:conditions => ['sum_points >= ?', LEVELS.keys.sort.first]}
  }
  named_scope :participants, :select => 'users.*, (select count(*) from tasks where completed_at is not null and tasks.user_id = users.id) as num_tasks', :conditions => 'num_tasks > 0'
  named_scope :participants_in, lambda {|campaign| {
    :select => "users.*, (select count(*) from tasks where completed_at is not null and campaign_id = #{campaign.id} and tasks.user_id = users.id) as num_tasks", 
    :conditions => 'num_tasks > 0'
  }}
  
  
  named_scope :campaign_subscribers, :conditions => ['subscribe_campaigns = ?', true]
  
  acts_as_authentic
  
  def total_points
    tasks.sum :points, :conditions => 'completed_at is not null'
  end
  
  def campaign_points(campaign)
    tasks.sum :points, :conditions => ['completed_at is not null and campaign_id = ?', campaign.id]
  end
  
  def campaigns_percent_complete
    completed = campaigns.all.map {|c| c.tasks.completed.count}.sum
    runs = campaigns.sum(:runs).to_f
    runs <= 0 ? 0 : ((completed / runs) * 100).to_i
  end
  
  def campaigns_participants_count
    campaigns.all.map {|c| User.participants_in(c)}.flatten.uniq.size
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
  
  Paperclip.interpolates :gender do |attachment, style|
    [:female, :male][rand 2]
  end
  
end