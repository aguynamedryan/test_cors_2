# Use the barebones version of Ruby 2.2.3.
FROM phusion/passenger-ruby22

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Ryan Duryea <aguynamedryan@gmail.com>

# Change user and group IDs around:
# http://stackoverflow.com/a/32171596
RUN usermod -u 1000 app
RUN usermod -G staff app

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# === 2 ===
# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# === 3 ====
# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx info
ADD config/nginx.conf /etc/nginx/sites-enabled/test_cors_2.conf

# === 4 ===
# Prepare folders
ENV INSTALL_PATH /home/app/test_cors_2
RUN mkdir -p $INSTALL_PATH

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client-9.4: In case you want to talk directly to postgres
#RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 git zip --fix-missing --no-install-recommends

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

COPY Gemfile* $INSTALL_PATH/

ENV BUNDLE_GEMFILE=$INSTALL_PATH/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/home/app/bundle

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# Provide dummy data to Rails so it can pre-compile assets.
#RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_TOKEN=pickasecuretoken assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$INSTALL_PATH/public"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
