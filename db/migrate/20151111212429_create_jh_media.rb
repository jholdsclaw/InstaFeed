class CreateJhMedia < ActiveRecord::Migration
  def change
    create_table :jh_media do |t|
      t.string :url_fullsize
      
      t.timestamps null: false
    end
  end
end
