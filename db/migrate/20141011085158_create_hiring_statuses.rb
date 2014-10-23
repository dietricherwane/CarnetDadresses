class CreateHiringStatuses < ActiveRecord::Migration
  def change
    create_table :hiring_statuses do |t|
      t.string :name
      t.boolean :published

      t.timestamps
    end
  end
end
