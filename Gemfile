source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise-jwt'
gem 'pg'
gem 'puma', '~> 5.2'
gem 'rails', '~> 6.1.3'
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
gem 'paper_trail'

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

  gem 'rspec-core', '~> 3.10.0'
  gem 'rspec-expectations', '~> 3.10.1'
  gem 'rspec-mocks', '~> 3.10.2'
  gem 'rspec-rails', '~> 5.0.1'
  gem 'rspec-support', '~> 3.10.2'
  gem 'bullet'
end

group :development do
  gem 'listen', '~> 3.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'webmock'
end
