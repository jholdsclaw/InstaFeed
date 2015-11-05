class AddMediaIdToMedia < ActiveRecord::Migration
  def change
    add_column :media, :media_id, :bigint
  end
end
