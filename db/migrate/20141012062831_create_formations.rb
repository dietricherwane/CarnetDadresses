class CreateFormations < ActiveRecord::Migration
  def change
    create_table :formations do |t|
      t.integer :year
      t.string :school, limit: 100
      t.string :diploma, limit: 150

      t.timestamps
    end
  end
end
