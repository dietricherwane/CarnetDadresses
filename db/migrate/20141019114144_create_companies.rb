class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :shortcut
      t.integer :social_status_id
      t.string :trading_identifier
      t.string :employees_amount
      t.string :capital
      t.string :turnover
      t.string :phone_number, limit: 20
      t.string :fax, limit: 20
      t.string :website
      t.string :email
      t.integer :country_id
      t.string :city
      t.string :geographical_address
      t.string :postal_address
      t.integer :sector_id
      t.integer :holding_id
      t.string :activities

      t.timestamps
    end
  end
end
