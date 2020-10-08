class CreateWhitelabels < ActiveRecord::Migration[6.0]
  def change
    create_table :whitelabels, id: :uuid do |t|
      t.string :name
      t.text :intro_text
      t.string :privacy_url
      t.boolean :formal_address
      t.string :background_color
      t.string :primary_highlight_color
      t.string :secondary_highlight_color
      t.integer :logo_small_width
      t.integer :logo_small_height
      t.integer :logo_big_width
      t.integer :logo_big_height

      t.timestamps
    end

    add_reference :owners, :whitelabel, foreign_key: true, type: :uuid
    add_reference :frontends, :whitelabel, foreign_key: true, type: :uuid

  end
end
