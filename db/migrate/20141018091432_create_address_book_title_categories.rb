class CreateAddressBookTitleCategories < ActiveRecord::Migration
  def change
    create_table :address_book_title_categories do |t|
      t.string :name
      t.boolean :published

      t.timestamps
    end
  end
end
