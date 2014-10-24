class Remove < ActiveRecord::Migration
  def change
    remove_column :forum_posts, :forum_theme_id
    add_column :forum_posts, :forum_themes_id, :integer
  end
end
