class Organization < ActiveRecord::Base
  has_many :campaigns
  has_one :user
  
  validates_presence_of :name
end