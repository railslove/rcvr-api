class DropJwtBlacklists < ActiveRecord::Migration[6.0]
  def change
    drop_table :jwt_blacklists
  end
end
