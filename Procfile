release: bundle exec rails db:migrate
web: bundle exec rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -C config/sidekiq.yml -e $RAILS_ENV
