class AddMinMaxIdToHashtag < ActiveRecord::Migration
  def change
    add_column :hashtags, :min_tag_id, :bigint
    add_column :hashtags, :max_tag_id, :bigint
  end
end
