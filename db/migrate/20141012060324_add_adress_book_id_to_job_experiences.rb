class AddAdressBookIdToJobExperiences < ActiveRecord::Migration
  def change
    add_column :job_experiences, :adress_book_id, :integer
  end
end
