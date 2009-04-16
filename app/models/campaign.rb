class Campaign < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :name, :keyword, :points
  validates_uniqueness_of :keyword
end