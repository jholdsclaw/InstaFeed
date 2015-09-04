class Tag < ActiveRecord::Base
  belongs_to :hastag
  belongs_to :medium
  
end
