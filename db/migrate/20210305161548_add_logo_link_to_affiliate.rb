class AddLogoLinkToAffiliate < ActiveRecord::Migration[6.0]
  def change
    add_column :affiliates, :logo_link, :string
  end
end
