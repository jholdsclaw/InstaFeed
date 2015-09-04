class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.belongs_to :hashtag, index: true
      t.belongs_to :medium, index: true

      t.timestamps null: false
    end
  end
end
