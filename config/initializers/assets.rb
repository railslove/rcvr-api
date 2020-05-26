# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.

# foundation_emails for our inky mail templates
Rails.application.config.assets.precompile += %w[foundation_emails.css]
