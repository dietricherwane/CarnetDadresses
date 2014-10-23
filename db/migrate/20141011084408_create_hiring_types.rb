class CreateHiringTypes < ActiveRecord::Migration
  def change
    create_table :hiring_types do |t|
      t.string :name
      t.boolean :published

      t.timestamps
    end
  end
end
