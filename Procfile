web: bundle exec rails server -p $PORT
release: rake db:migrate
worker: bundle exec sidekiq -q default -q mailers -t 25 -c 5 -v
