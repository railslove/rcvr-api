class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets, id: :uuid do |t|
      t.datetime :entered_at
      t.datetime :left_at
      t.references :company, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
