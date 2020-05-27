class AddTrialThingsToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :trial_ends_at, :datetime
    add_column :owners, :can_use_for_free, :boolean, default: false
  end
end
