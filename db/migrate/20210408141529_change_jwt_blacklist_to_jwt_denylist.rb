class ChangeJwtBlacklistToJwtDenylist < ActiveRecord::Migration[6.0]
  def change
    rename_table :jwt_blacklist, :jwt_denylist
  end
end
