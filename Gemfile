# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 6.5"
gem "rails", "~> 7.1.3"
gem "jbuilder", "~> 2.13"

gem "active_median"
gem "bootsnap", ">= 1.4.2", require: false
gem "rack-cors", require: "rack/cors"
gem "yt"
gem "dotenv"
gem "scout_apm"
gem "rollbar"
gem "watir"


group :development, :test do
  gem "brakeman", ">=5.2.1", require: false
  gem "faker"
  gem "pry-byebug"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rake"
  gem "rubocop-rspec"
end

group :test do
  gem "shoulda-matchers"
end

group :development do
  gem "listen", "~> 3.9"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
