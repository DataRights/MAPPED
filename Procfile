web: bundle exec rails server -p $PORT
release: rake assets:precompile && rake db:migrate && rake db:seed
worker: bundle exec sidekiq -q default -q mailers -t 25 -c 5 -v
