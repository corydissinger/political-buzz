class Statement < ActiveRecord::Base
  attr_accessible :transcript, :url, :speaker, :date
  belongs_to :topic
  has_and_belongs_to_many :categories  
end
