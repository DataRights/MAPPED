source 'https://rubygems.org'
ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Begin Default rails gems #
# gem 'foreman'  # HA:from dockerfile

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
# Use PostgreSQL as the database for Active Record
gem 'pg', '~> 0.21'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.12'  #HA

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'

  gem 'dotenv-rails', groups: [:development, :test]
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# End Default rails gems #

# Begin gems added for DataInSight project #

# Use devise for user management and authentication solution
gem 'devise', '~> 4.3'

# for sending devise emails in background
gem 'devise-async'

# theme for devise
gem 'devise-bootstrap-views'

# Devise-Two-Factor is a minimalist extension to Devise which offers support for two-factor authentication, through the TOTP scheme.
gem 'devise-two-factor'

#An invitation strategy for devise
gem 'devise_invitable', '~> 1.7.0'

# For generating devise-two-factor QRCodes
gem 'rqrcode-rails3'

# Use annotate to insert column names in model
gem 'annotate'

# Use simplecov for code coverage reports
gem 'simplecov', :group => :test

# You never have to implement CRUD again! lazy/happy programming ...
gem 'rails_admin'

# Bootstrap JavaScript depends on jQuery. If you're using Rails 5.1+, add the jquery-rails gem to your Gemfile:
gem 'jquery-rails'

# This theme provide a modern override of default bootstrap 3 rails_admin theme. Its provides news colors, adjustments and a brand new tree view menu.
gem 'rails_admin_rollincode'

# Bootstrap 4 ruby gem for Ruby on Rails (Sprockets) and Hanami (formerly Lotus).
gem 'bootstrap', '~> 4.0.0.beta2.1'

# Bootstrap Toggle is a highly flexible Bootstrap plugin that converts checkboxes into toggles.
gem 'bootstrap-toggle-rails'

group :development do
  # https://github.com/jish/pre-commit
  # A better pre-commit hook for git.
  gem "pre-commit", require: false
  gem "rubocop", require: false

  # generate a diagram based on your application's Active Record models
  gem 'rails-erd', require: false
end

# deliver code confidently by showing which parts of your code aren’t covered by your test suite.
gem 'coveralls', require: false

# for sending emails
gem 'sendgrid-ruby'

# Ruby/Graphviz provides an interface to layout and generate images of directed graphs in a variety of formats (PostScript, PNG, etc.) using GraphViz.
gem 'ruby-graphviz', '~> 1.2', '>= 1.2.3'

gem 'liquid'

gem 'ckeditor', github: 'galetahub/ckeditor'

gem 'wkhtmltopdf-binary'

gem 'wicked_pdf'

gem 'pdfjs_rails'

#HA:
gem 'sidekiq'

#gem 'redis'

gem 'rmagick'

# For memcached
gem 'dalli'

# N + Queries
gem 'bullet', group: 'development'

gem 'js_cookie_rails'

# A Ruby gem that provides the ISO 639-2 and ISO 639-1 data sets along with some convenience methods for accessing different entries and entry fields. The data comes from the LOC ISO 639-2 UTF-8 data set.
gem 'iso639'

# Explore your data with SQL. Easily create charts and dashboards, and share them with your team.
gem 'blazer'

# Poltergeist is a driver for Capybara. It allows you to run your Capybara tests on a headless WebKit browser, provided by PhantomJS.
# gem 'poltergeist'
