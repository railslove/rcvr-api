class RemoveFieldNameFromOwner < ActiveRecord::Migration[6.0]
  def change
    remove_column :owners, :sepa_trial, :boolean
  end
end
