#!/bin/bash

rails new $1 --webpack --database=postgresql --skip-coffee
cp serveur.sh $1/
cd $1
echo "gem 'devise'" >> ./Gemfile
echo "gem 'stripe'" >> ./Gemfile
echo "group :development, :test do" >> ./Gemfile
echo "gem 'rspec'" >> ./Gemfile
echo "gem 'pry-rails'" >> ./Gemfile
echo "gem 'faker'" >> ./Gemfile
echo "end" >> ./Gemfile
bundle install
rails g devise:install && rails g devise user && rails g migration add_default_value_to_user
sed -i '3,4d' db/migrate/*default*
echo -e "add_column :users, :admin, :boolean, default: false\nend\nend" >> db/migrate/*default*
rails db:create
rails db:migrate
rails generate devise:views
