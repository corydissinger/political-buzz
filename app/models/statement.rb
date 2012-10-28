class Statement < ActiveRecord::Base
  attr_accessible :transcript, :url, :speaker, :date
  has_and_belongs_to_many :categories  
end
