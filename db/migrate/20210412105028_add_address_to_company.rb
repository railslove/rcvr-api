class AddAddressToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :street, :string
    add_column :companies, :zip, :string
    add_column :companies, :city, :string
  end
end
