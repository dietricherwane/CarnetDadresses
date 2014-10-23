class CreateSubSalesAreas < ActiveRecord::Migration
  def change
    create_table :sub_sales_areas do |t|
      t.string :name
      t.boolean :published
      t.integer :sales_area_id

      t.timestamps
    end
  end
end
