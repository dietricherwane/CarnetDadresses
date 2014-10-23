class CreateCivilities < ActiveRecord::Migration
  def change
    create_table :civilities do |t|
      t.string :name, limit: 10

      t.timestamps
    end
  end
end
