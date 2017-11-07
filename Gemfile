source 'https://rubygems.org'
ruby '2.3.5'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Begin gems added for MAPPED project #

# Use devise for user management and authentication solution
gem 'devise', '~> 4.3'

# theme for devise
gem 'devise-bootstrap-views'

# Devise-Two-Factor is a minimalist extension to Devise which offers support for two-factor authentication, through the TOTP scheme.
gem 'devise-two-factor'

# For generating devise-two-factor QRCodes
gem 'rqrcode-rails3'

# Use annotate to insert column names in model
gem 'annotate'

# Use simplecov for code coverage reports
gem 'simplecov', :group => :test

# You never have to implement CRUD again! lazy/happy programming ...
gem 'rails_admin'

# This theme provide a modern override of default bootstrap 3 rails_admin theme. Its provides news colors, adjustments and a brand new tree view menu.
gem 'rails_admin_rollincode', '~> 1.0'

group :development do
  # https://github.com/jish/pre-commit
  # A better pre-commit hook for git.
  gem "pre-commit", require: false
  gem "rubocop", require: false
end

# deliver code confidently by showing which parts of your code aren’t covered by your test suite.
gem 'coveralls', require: false

# for sending emails
gem 'sendgrid-ruby'

# End gems for MAPPED project #


# Begin Default rails gems #

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
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
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
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

gem 'liquid'

gem 'ckeditor'
