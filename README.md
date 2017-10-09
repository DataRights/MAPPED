# MAPPED

MAPPED is a platform that helps citizens to send access requests to organizations. An access request is a request by a citizen to receive from an organization (information about) the personal data that that organization is processing in relation to him/her. The right to receive a swift, complete and understandable answer to such a request, called right of access, is guaranteed under European law in order to promote citizen empowerment.

This README documents steps that are necessary to set the development environment for application up and running.

# Ruby version

We are using the latest stable version of Ruby 2.3. You can install Ruby version using [rvm](https://rvm.io). 

# System dependencies

This steps should work on macOS and different distros of Linux as well as other Unix based operating systems.

Install bundler if it's not already installed:

`gem install bundler` 

Go to the root directory of project and run:

`bundle install`

# Configuration

Copy config/database.yml.template to config/database.yml and configure connection string according to your own system settings. We are using PostgreSQL 9.6.5 but there is no dependency on PostgreSQL, So you can run MySql and other Active Record supported datbase servers as well.

# Database creation and initalization

`bundle exec rake db:setup`

# How to run the test suite

`bundle exec rake test`

# Deployment instructions

Not documented yet.
