class AddCompanyShortcutToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :company_shortcut, :string
  end
end
