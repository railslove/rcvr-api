class ChangeJwtBlacklistToJwtDenylist < ActiveRecord::Migration[6.0]
  def change
    rename_table :jwt_blacklist, :jwt_denylist
    add_column :jwt_denylist, :exp, :datetime
    drop_table :jwt_blacklists
  end
end
