class JhMedium < ActiveRecord::Base

  def next
    self.class.where("id > ?", id).first
  end

  def previous
    self.class.where("id < ?", id).last
  end
  
end
