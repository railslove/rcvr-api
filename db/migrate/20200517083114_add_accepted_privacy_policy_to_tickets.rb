class AddAcceptedPrivacyPolicyToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :accepted_privacy_policy, :boolean
  end
end
