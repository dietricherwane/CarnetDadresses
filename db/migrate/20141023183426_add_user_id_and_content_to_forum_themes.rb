class AddUserIdAndContentToForumThemes < ActiveRecord::Migration
  def change
    add_column :forum_themes, :user_id, :integer
    add_column :forum_themes, :content, :text
  end
end
