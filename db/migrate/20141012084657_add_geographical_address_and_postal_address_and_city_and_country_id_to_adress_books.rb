class AddGeographicalAddressAndPostalAddressAndCityAndCountryIdToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :geographical_address, :string
    add_column :adress_books, :postal_address, :string
    add_column :adress_books, :city, :string
    add_column :adress_books, :country_id, :integer
  end
end
