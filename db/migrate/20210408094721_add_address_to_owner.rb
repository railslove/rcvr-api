class AddAddressToOwner < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :street, :string
    add_column :owners, :zip, :string
    add_column :owners, :city, :string
  end
end
