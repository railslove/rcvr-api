class AddCoronaTestCheckboxToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :need_to_show_corona_test, :boolean, default: false
  end
end
