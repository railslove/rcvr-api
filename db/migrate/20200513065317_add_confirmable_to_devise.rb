class AddConfirmableToDevise < ActiveRecord::Migration[6.0]
  # Note: You can't use change, as Owner.update_all will fail in the down migration
  def up
    add_column :owners, :confirmation_token, :string
    add_column :owners, :confirmed_at, :datetime
    add_column :owners, :confirmation_sent_at, :datetime
    add_index :owners, :confirmation_token, unique: true

    Owner.update_all confirmed_at: DateTime.now
  end

  def down
    remove_columns :owners, :confirmation_token, :confirmed_at, :confirmation_sent_at
    # remove_columns :owners, :unconfirmed_email # Only if using reconfirmable
  end
end
