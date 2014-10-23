class AddUserIdToAdressBookHobbies < ActiveRecord::Migration
  def change
    add_column :adress_book_hobbies, :user_id, :integer
  end
end
