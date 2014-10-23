class CreateAddFaxToAdressBooks < ActiveRecord::Migration
  def change
    create_table :add_fax_to_adress_books do |t|
      t.string :fax, limit: 16

      t.timestamps
    end
  end
end
