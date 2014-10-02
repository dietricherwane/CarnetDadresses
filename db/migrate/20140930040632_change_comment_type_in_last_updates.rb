class ChangeCommentTypeInLastUpdates < ActiveRecord::Migration
  def change
    remove_column :last_updates, :comment
    remove_column :last_updates, :new_comment
    
    add_column :last_updates, :comment, :text
    add_column :last_updates, :new_comment, :text
  end
end
