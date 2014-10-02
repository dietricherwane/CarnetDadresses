class CreateSocialStatuses < ActiveRecord::Migration
  def change
    create_table :social_statuses do |t|
      t.string :name, limit: 100
      t.boolean :published
      t.integer :user_id

      t.timestamps
    end
  end
end
