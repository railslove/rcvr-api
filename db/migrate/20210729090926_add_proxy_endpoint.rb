class AddProxyEndpoint < ActiveRecord::Migration[6.1]
  def change
    add_column :data_requests, :proxy_endpoint, :string
  end
end
