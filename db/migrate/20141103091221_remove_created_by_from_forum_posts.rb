class RemoveCreatedByFromForumPosts < ActiveRecord::Migration
  def change
    remove_column :forum_posts, :created_by
  end
end
