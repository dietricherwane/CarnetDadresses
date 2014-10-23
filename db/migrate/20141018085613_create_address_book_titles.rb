class CreateAddressBookTitles < ActiveRecord::Migration
  def change
    create_table :address_book_titles do |t|
      t.string :name
      t.boolean :published

      t.timestamps
    end
  end
end
