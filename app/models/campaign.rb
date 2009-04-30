class Campaign < ActiveRecord::Base
  belongs_to :organization
  has_many :tasks
  
  validates_presence_of :name, :keyword, :points, :url, :runs
  validates_numericality_of :runs, :greater_than => 0
  validates_uniqueness_of :keyword
  
  def percent_complete
    ((tasks.completed.count.to_f / runs.to_f) * 100).to_i
  end
end