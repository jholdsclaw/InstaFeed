class ConvertInstagramIdstoString < ActiveRecord::Migration
  def change
    change_column :media, :media_id, :string
    change_column :hashtags, :min_tag_id, :string
    change_column :hashtags, :max_tag_id, :string
  end
end
