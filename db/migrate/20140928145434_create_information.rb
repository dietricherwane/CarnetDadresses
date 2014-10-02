class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.text :content
      t.boolean :published
      t.integer :created_by

      t.timestamps
    end
  end
end
