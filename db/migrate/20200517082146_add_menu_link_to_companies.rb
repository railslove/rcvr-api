class AddMenuLinkToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :menu_link, :string
  end
end
