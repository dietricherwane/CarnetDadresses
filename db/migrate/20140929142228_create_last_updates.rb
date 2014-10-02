class CreateLastUpdates < ActiveRecord::Migration
  def change
    create_table :last_updates do |t|
      t.integer :user_id
      t.integer :update_type_id
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
      
      t.string :new_firstname, limit: 100
      t.string :new_lastname, limit: 100
      t.string :new_company_name, limit: 100
      t.string :new_email, limit: 100
      t.string :new_phone_number, limit: 100
      t.string :new_mobile_number, limit: 100
      t.integer :new_profile_id
      t.integer :new_social_status_id
      t.string :new_trading_identifier, limit: 100
      t.integer :new_created_by
      t.boolean :new_published
      t.integer :new_sector_id
      t.integer :new_sales_area_id
      t.integer :new_comment
      
      t.timestamps
    end
  end
end
