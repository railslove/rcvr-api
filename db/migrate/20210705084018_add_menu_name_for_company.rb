class AddMenuNameForCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :menu_alias, :string
    remove_column :owners, :menu_alias
  end
end
