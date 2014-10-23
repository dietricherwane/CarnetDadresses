class AddAdressBookIdToFormations < ActiveRecord::Migration
  def change
    add_column :formations, :adress_book_id, :integer
  end
end
