class AddShortcutAndLogoAndCommentsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shortcut, :string, limit: 15
    add_column :users, :comment, :text
    add_column :users, :logo, :string
  end
end
