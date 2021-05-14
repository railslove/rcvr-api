class AddAffiliateRefToOwners < ActiveRecord::Migration[6.1]
  def change
    add_reference :owners, :affiliates, foreign_key: true
  end
end
