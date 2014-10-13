class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.string :name
      t.string :shortcut
      t.integer :number_of_companies
      t.string :phone_number, limit: 16
      t.string :website
      t.string :email
      t.string :geographical_address
      t.string :postal_address
      t.integer :country_id
      t.string :city
      t.text :activities

      t.timestamps
    end
  end
end
