class AddApiTokenToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :api_token, :string
  end
end
