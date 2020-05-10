class AddOwnerToCompany < ActiveRecord::Migration[6.0]
  def change
    add_reference :companies, :owner, foreign_key: true
  end
end
