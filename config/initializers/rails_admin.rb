RailsAdmin.config do |config|
  config.authenticate_with do
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' &&
      password == ENV['RAILS_ADMIN_PASSWORD']
    end
  end

  config.parent_controller = "::RailsAdminController"

  config.included_models = %w[Area Company Owner Ticket]

  config.actions do
    dashboard
    index
    new
    show
    edit
    delete
  end
end
