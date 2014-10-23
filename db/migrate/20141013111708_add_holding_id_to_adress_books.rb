class AddHoldingIdToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :holding_id, :integer
  end
end
