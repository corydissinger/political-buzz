class Category < ActiveRecord::Base
  validates :name, :uniqueness => true, :allow_blank => false, :allow_nil => false
  attr_accessible :name
  has_and_belongs_to_many :statements
  has_many :articles
end
