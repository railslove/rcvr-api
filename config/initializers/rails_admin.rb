require Rails.root.join('lib/rails_admin/accept_data_request.rb')

RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::AcceptDataRequest)

RailsAdmin.config do |config|
  config.authenticate_with do
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' &&
      password == ENV['RAILS_ADMIN_PASSWORD']
    end
  end

  # Lets show empty fields
  config.compact_show_view = false

  config.parent_controller = "::RailsAdminController"

  config.included_models = %w[Area Company Owner Ticket DataRequest]

  config.actions do
    dashboard
    index
    new
    show
    edit
    delete
    bulk_delete
    export
    accept_data_request
  end
end
