class AddsMenuAliasToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :menu_alias, :string
  end
end
