class AddReasonToDataRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :data_requests, :reason, :string
  end
end
