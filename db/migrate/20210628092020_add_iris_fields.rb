class AddIrisFields < ActiveRecord::Migration[6.1]
  def change
    remove_column :data_requests, :iris_health_department
    remove_column :data_requests, :iris_key_of_health_department
    add_column :data_requests, :iris_client_name, :string
    add_column :data_requests, :iris_data_authorization_token, :text
    add_column :data_requests, :iris_connection_authorization_token, :text
  end
end
