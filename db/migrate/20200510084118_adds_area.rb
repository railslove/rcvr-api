class AddsArea < ActiveRecord::Migration[6.0]
  def change
    create_table :areas, id: :uuid do |t|
      t.timestamps

      t.string :name
      t.references :company, type: :uuid, foreign_key: true
    end
  end
end
