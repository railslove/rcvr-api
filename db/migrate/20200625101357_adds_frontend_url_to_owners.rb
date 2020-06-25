class AddsFrontendUrlToOwners < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :frontend_url, :string
  end
end
