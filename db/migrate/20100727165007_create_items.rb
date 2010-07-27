class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title
      t.text :description
      t.datetime :publishing_date
      t.string :categories
      t.integer :vote_up
      t.integer :vote_down
      t.integer :clicks
      t.integer :comments
      t.string :thumbnail
      t.string :submitter_name
      t.string :submitter_image

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
