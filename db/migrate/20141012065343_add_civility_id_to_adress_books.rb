class AddCivilityIdToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :civility_id, :integer
  end
end
