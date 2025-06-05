source "https://rubygems.org"

gem "rails", ENV["RAILS_VERSION"] || raise(<<~ERR)

>>>>> ATTENTION <<<<<

You are attempting something outside of 'bin/test'. If you are wanting to
run tests, utilize 'bin/test'. Otherwise, set the RAILS_VERSION variable prior to
your current action.

ERR

gem "sqlite3"
gem "test-unit"

# Specify your gem's dependencies in pry-rails.gemspec
gemspec
