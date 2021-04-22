class AddIrisFieldsToDataRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :data_requests, :iris_submission_url, :string
    add_column :data_requests, :iris_health_department, :text
    add_column :data_requests, :iris_key_of_health_department, :text
    add_column :data_requests, :iris_key_reference, :text
    add_index :data_requests, :accepted_at
  end
end
