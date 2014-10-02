class CreateNewsFeeds < ActiveRecord::Migration
  def change
    create_table :news_feeds do |t|
      t.string :title
      t.text :content
      t.datetime :publication_date
      t.boolean :published
      t.integer :user_id
      t.string :picture

      t.timestamps
    end
  end
end
