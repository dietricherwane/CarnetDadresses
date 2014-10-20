class CreatePreviousJobExperiences < ActiveRecord::Migration
  def change
    create_table :previous_job_experiences do |t|
      t.date :begin_date
      t.date :end_date
      t.string :company_name
      t.string :role
      t.integer :membership_id
      t.integer :user_id
      t.boolean :published

      t.timestamps
    end
  end
end
