class AddAddressBookTitleCategoryIdToAddressBookTitles < ActiveRecord::Migration
  def change
    add_column :address_book_titles, :address_book_title_category_id, :integer
  end
end
