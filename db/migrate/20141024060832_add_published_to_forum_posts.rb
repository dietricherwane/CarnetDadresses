class AddPublishedToForumPosts < ActiveRecord::Migration
  def change
    add_column :forum_posts, :published, :boolean
  end
end
