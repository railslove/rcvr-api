class AddAutoCheckoutMinutesToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :auto_checkout_minutes, :integer
  end
end
