class CreateForumPosts < ActiveRecord::Migration
  def change
    create_table :forum_posts do |t|
      t.text :comment
      t.integer :created_by
      t.boolean :unpublished
      t.datetime :unpublished_at
      t.integer :unpublished_by
      t.integer :forum_theme_id

      t.timestamps
    end
  end
end
