class CreateAdressBooks < ActiveRecord::Migration
  def change
    create_table :adress_books do |t|
      t.string :firstname, limit: 100
      t.string :lastname, limit: 100
      t.string :company_name, limit: 100
      t.string :email, limit: 100
      t.string :phone_number, limit: 100
      t.string :mobile_number, limit: 100
      t.integer :profile_id
      t.integer :social_status_id
      t.string :trading_identifier, limit: 100
      t.integer :created_by
      t.boolean :published
      t.integer :sector_id
      t.integer :sales_area_id
      t.integer :comment

      t.timestamps
    end
  end
end
