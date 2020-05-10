class AddOwnerAttributes < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :name, :string
    add_column :owners, :public_key, :string
  end
end
