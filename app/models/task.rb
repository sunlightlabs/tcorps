class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign
  
  validates_presence_of :key
  validates_uniqueness_of :key
  
  named_scope :completed, :conditions => 'completed_at IS NOT NULL'
  named_scope :for_user, lambda {|user|
    {:conditions => {:user_id => user.id}}
  }
  
  def before_validation_on_create
    self.points = campaign.points
    self.key = ActiveSupport::SecureRandom.hex 16
  end
  
  def before_create
    if campaign.complete? or campaign.complete?(user)
      errors.add_to_base 'Cannot assign this user any more tasks for this campaign.' 
      false
    end
  end
  
  def complete?
    !completed_at.nil?
  end
end