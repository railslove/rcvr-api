class AddExpirationTimeToJwtDenylist < ActiveRecord::Migration[6.0]
  def change
    add_column :jwt_denylist, :exp, :datetime, null: false
  end
end
