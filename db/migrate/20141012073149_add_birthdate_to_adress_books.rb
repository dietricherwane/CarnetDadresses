class AddBirthdateToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :birthdate, :date
  end
end
