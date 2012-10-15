class Article < ActiveRecord::Base
  validates :url, :uniqueness => true
  attr_accessible :url
  belongs_to :category
end
