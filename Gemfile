source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise-jwt'
gem 'pg'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3'
gem 'sentry-raven'
gem 'happypdf_renderer', git: 'https://ef44d43b3bd2bcace3681ac53e1553a1a4f98eda:x-oauth-basic@github.com/railslove/happypdf_renderer.git'
gem 'interactor-rails'
gem 'rack-cors'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'rails_admin'
gem 'stripe'
gem 'rqrcode'
gem "aws-sdk-s3", require: false
gem 'activestorage-validator'
gem 'image_processing'

# Emails
gem 'mailgun-ruby', '~> 1.2'
gem 'inky-rb', require: 'inky'
gem 'premailer-rails'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'letter_opener'

  # Bleeding edge testing / required for rails 6 with rspec
  gem 'rspec-core', github: 'rspec/rspec-core'
  gem 'rspec-expectations', github: 'rspec/rspec-expectations'
  gem 'rspec-mocks', github: 'rspec/rspec-mocks'
  gem 'rspec-rails', github: 'rspec/rspec-rails'
  gem 'rspec-support', github: 'rspec/rspec-support'
  gem 'bullet'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'webmock'
end
