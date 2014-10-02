class CreateUpdateTypes < ActiveRecord::Migration
  def change
    create_table :update_types do |t|
      t.string :name, limit: 50
      t.integer :created_by
      t.boolean :published

      t.timestamps
    end
  end
end
