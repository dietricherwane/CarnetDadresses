class AddAddressBookTitleIdToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :address_book_title_id, :integer
  end
end
