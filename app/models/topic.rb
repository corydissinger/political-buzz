class Topic < ActiveRecord::Base
  validates :name, :uniqueness => true
  attr_accessible :name, :count
  has_many :statements
end
