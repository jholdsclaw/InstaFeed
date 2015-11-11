class Medium < ActiveRecord::Base
  has_many :tags
  has_many :hashtags, through: :tags
  
end
