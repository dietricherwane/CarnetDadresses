class CreateAdressBookHobbies < ActiveRecord::Migration
  def change
    create_table :adress_book_hobbies do |t|
      t.integer :adress_book_id
      t.integer :hobby_id

      t.timestamps
    end
  end
end
