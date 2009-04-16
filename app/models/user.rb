class User < ActiveRecord::Base
  acts_as_authentic

  belongs_to :organization
  has_many :tasks
  
  validates_presence_of :login, :email
  validates_uniqueness_of :login, :email
end