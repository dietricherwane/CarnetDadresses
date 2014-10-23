class CreateHobbies < ActiveRecord::Migration
  def change
    create_table :hobbies do |t|
      t.string :name
      t.boolean :published

      t.timestamps
    end
  end
end
