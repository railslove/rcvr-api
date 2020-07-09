class AddIsFreeToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :is_free, :boolean, default: false
  end
end
