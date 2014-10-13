class AddMaritalStatusIdAndChildrensAndHobbiesToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :marital_status_id, :integer
    add_column :adress_books, :childrens, :integer
    add_column :adress_books, :hobbies, :text
  end
end
