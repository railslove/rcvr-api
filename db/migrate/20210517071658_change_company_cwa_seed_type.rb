class ChangeCompanyCwaSeedType < ActiveRecord::Migration[6.1]
  def change
    remove_column :companies, :cwa_crypto_seed
    add_column :companies, :cwa_crypto_seed, :string
  end
end
