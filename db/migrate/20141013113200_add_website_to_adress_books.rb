class AddWebsiteToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :website, :string
  end
end
