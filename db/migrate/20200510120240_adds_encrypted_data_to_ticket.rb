class AddsEncryptedDataToTicket < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :encrypted_data, :string
    add_column :tickets, :encrypted_private_key, :string

    remove_reference :tickets, :company, type: :uuid, foreign_key: true
    add_reference :tickets, :area, type: :uuid, foreign_key: true
  end
end
