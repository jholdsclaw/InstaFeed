class Hashtag < ActiveRecord::Base
  has_many :tags
  has_many :media, through: :tags
  
end
