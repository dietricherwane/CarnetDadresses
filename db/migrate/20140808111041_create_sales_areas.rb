class CreateSalesAreas < ActiveRecord::Migration
  def change
    create_table :sales_areas do |t|
      t.string :name, limit: 100
      t.boolean :published
      t.integer :created_by

      t.timestamps
    end
  end
end
