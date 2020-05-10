class AddsEncryptedPrivateKeyToTheRightModel < ActiveRecord::Migration[6.0]
  def change
    remove_column :companies, :encrypted_private_key, :string
    add_column :owners, :encrypted_private_key, :string
  end
end
