class AddAffiliateToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :affiliate, :string
  end
end
