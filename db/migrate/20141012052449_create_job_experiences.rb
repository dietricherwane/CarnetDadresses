class CreateJobExperiences < ActiveRecord::Migration
  def change
    create_table :job_experiences do |t|
      t.date :begin_date
      t.date :end_date
      t.string :company, limit: 100
      t.integer :team_members
      t.string :role
      t.integer :hiring_status_id
      t.text :missions
      t.integer :hiring_type_id
      t.string :predecessor_firstname, limit: 100
      t.string :predecessor_lastname, limit: 100
      t.string :phone_number, limit: 16
      t.string :email, limit: 100
      t.string :superior_firstname, limit: 100
      t.string :superior_lastname, limit: 100
      t.string :superior_title, limit: 100
      t.integer :membership_id
      t.text :misc

      t.timestamps
    end
  end
end
