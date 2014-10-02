class ChangeCommentTypeToTextInAdressBooks < ActiveRecord::Migration
  def change
    remove_column :adress_books, :comment
    add_column :adress_books, :comment, :text
  end
end
