class AddsEncryptedDataToTicket < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :encrypted_data, :string
  end
end
