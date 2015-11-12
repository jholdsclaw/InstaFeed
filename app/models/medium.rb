class Medium < ActiveRecord::Base
  has_many :tags
  has_many :hashtags, through: :tags

  def next
    self.class.where("id > ?", id).first
  end

  def previous
    self.class.where("id < ?", id).last
  end
  
end
