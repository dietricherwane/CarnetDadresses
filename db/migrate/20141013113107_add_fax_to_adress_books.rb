class AddFaxToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :fax, :string, limit: 16
  end
end
