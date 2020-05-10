# frozen_string_literal: true

class DeviseCreateOwners < ActiveRecord::Migration[6.0]
  def change
    create_table :owners do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :owners, :email,                unique: true
    add_index :owners, :reset_password_token, unique: true
    # add_index :owners, :confirmation_token,   unique: true
    # add_index :owners, :unlock_token,         unique: true
  end
end
