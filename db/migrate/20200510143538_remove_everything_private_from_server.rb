class RemoveEverythingPrivateFromServer < ActiveRecord::Migration[6.0]
  def change
    remove_column :owners, :encrypted_private_key, :string
    remove_column :tickets, :encrypted_private_key, :string
  end
end
