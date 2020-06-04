# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.

# foundation_emails for our inky mail templates
Rails.application.config.assets.precompile += %w[foundation_emails.css]

# Workaround for Segfault
# https://github.com/sass/sassc-ruby/issues/197
Rails.application.config.assets.configure do |env|
  env.export_concurrent = false
end
