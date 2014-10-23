class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :alt
      t.string :hint
      t.attachment :file

      t.timestamps
    end
  end
end
