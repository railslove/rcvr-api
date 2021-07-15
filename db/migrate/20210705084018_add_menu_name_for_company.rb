class AddMenuNameForCompany < ActiveRecord::Migration[6.1]
  def up
    add_column :companies, :menu_alias, :string
    Owner.all.each do|owner|
      owner.companies.each { |company| company.update(menu_alias: owner.menu_alias) } if owner.menu_alias
    end
    remove_column :owners, :menu_alias
  end
  def down
    add_column :owners, :menu_alias, :string
    Owner.all.each do|owner|
      companies_with_menu_alias = owner.companies.filter{ |company| company.menu_alias.present? }
      owner.update(menu_alias: companies_with_menu_alias.first.menu_alias) if companies_with_menu_alias.present?
    end
    remove_column :companies, :menu_alias, :string
  end
end
