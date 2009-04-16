class User < ActiveRecord::Base
  belongs_to :organization
  has_many :tasks
  
  validates_presence_of :api_key, :login
  validates_uniqueness_of :api_key, :login
end