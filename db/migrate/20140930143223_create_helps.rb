class CreateHelps < ActiveRecord::Migration
  def change
    create_table :helps do |t|
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
