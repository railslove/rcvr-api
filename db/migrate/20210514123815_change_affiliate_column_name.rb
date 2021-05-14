class ChangeAffiliateColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :owners, :affiliate, :affiliate_code
  end
end
