class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :url_thumbnail
      t.string :url_fullsize
      
      t.string :caption
            
      t.timestamps null: false
    end
  end
end
