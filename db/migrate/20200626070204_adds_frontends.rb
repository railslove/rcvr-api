class AddsFrontends < ActiveRecord::Migration[6.0]
  def change
    create_table :frontends do |t|
      t.string :name
      t.string :url
    end

    remove_column :owners, :frontend_url, :string
    add_reference :owners, :frontend, foreign_key: true
  end
end
