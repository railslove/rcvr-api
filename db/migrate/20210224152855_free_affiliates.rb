class FreeAffiliates < ActiveRecord::Migration[6.0]
  def change
    add_column :affiliates, :free_usage, :boolean, default: :false
  end
end
