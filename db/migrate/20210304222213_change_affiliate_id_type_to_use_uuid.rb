class ChangeAffiliateIdTypeToUseUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :affiliates, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }

    remove_column :affiliates, :id
    rename_column :affiliates, :uuid, :id

    execute "ALTER TABLE affiliates ADD PRIMARY KEY (id);"

    add_index :affiliates, :code

  end
end
