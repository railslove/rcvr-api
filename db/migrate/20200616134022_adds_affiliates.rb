class AddsAffiliates < ActiveRecord::Migration[6.0]
  def change
    create_table :affiliates do |t|
      t.string :name
      t.string :code
      t.string :stripe_price_id_monthly
    end
  end
end
