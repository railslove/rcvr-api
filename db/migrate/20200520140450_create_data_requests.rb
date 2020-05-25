class CreateDataRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :data_requests do |t|
      t.references :company, foreign_key: true, type: :uuid
      t.datetime :from
      t.datetime :to
      t.datetime :accepted_at
    end
  end
end
