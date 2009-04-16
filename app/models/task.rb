class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign
  
  validates_presence_of :key
  validates_uniqueness_of :key
  
  def before_save
    self.points = campaign.points
  end
end