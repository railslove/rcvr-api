class AddNewRegistrationFieldsToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :phone, :string
    add_column :owners, :company_name, :string
  end
end
