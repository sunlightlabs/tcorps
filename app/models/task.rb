class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign
  
  asdfjkhasjh
  
  validates_presence_of :key
  validates_uniqueness_of :key
  
  def before_validation_on_create
    self.points = campaign.points
    self.key = ActiveSupport::SecureRandom.hex 16
  end
  
  def complete?
    !completed_at.nil?
  end
end