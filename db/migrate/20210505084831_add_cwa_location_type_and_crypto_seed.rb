class AddCwaLocationTypeAndCryptoSeed < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :location_type, :integer, default: 0
    add_column :companies, :cwa_link_enabled, :boolean, default: false
    add_column :companies, :cwa_crypto_seed, :binary
  end
end
