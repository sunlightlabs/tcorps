class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign
  
  def before_save
    self.points = campaign.points
  end
end