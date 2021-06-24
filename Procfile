release: bundle exec rails db:migrate
web: bin/qgtunnel bundle exec rails server -p $PORT -e $RAILS_ENV
worker: bin/qgtunnel bundle exec sidekiq -C config/sidekiq.yml -e $RAILS_ENV
