# Sentrum Aikido Website

The website of Sentrum Aikido.

# Setup local dev env

Make sure Ruby 1.9.3 or newer is installed. Install bundler "gem
install bundler". Then from the project root, run:

	bundle install

This should install all dependencies.


# Running the server process locally

Run the Sinatra process by running:

	bundle exec scripts/server

this runs the server process with all the gems in Gemfile included in
your environment.

# Run the test suite

Run all the unit/integration tests like so:

	bundle exec rake test


# Deploying to Heroku

	bundle exec rake deploy




## License

All rights reserved Sentrum Aikido.
