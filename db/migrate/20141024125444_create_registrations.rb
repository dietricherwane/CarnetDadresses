class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :user_id
      t.date :expires_at
      t.boolean :published
      t.integer :created_by
      t.integer :unpublished_by
      t.string :unpublished_at
      t.string :datetime
      t.string :transaction_id

      t.timestamps
    end
  end
end
