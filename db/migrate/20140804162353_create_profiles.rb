class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name, limit: 50
      t.string :shortcut, limit: 5
      t.integer :created_by
      t.boolean :published

      t.timestamps
    end
  end
end
