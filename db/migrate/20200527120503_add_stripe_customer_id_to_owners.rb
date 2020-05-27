class AddStripeCustomerIdToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :stripe_customer_id, :string
    add_column :owners, :stripe_subscription_id, :string
    add_column :owners, :stripe_subscription_status, :string
  end
end
