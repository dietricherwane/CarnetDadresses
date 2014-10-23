class AddPublishedToAdressBookHobbies < ActiveRecord::Migration
  def change
    add_column :adress_book_hobbies, :published, :boolean
  end
end
