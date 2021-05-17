class AddAffiliateRefToOwners < ActiveRecord::Migration[6.1]
  def change
    add_reference :owners, :affiliate, foreign_key: true, type: :uuid
  end
end
