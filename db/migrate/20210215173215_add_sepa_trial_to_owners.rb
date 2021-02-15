class AddSepaTrialToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :sepa_trial, :boolean, default: :false
  end
end
