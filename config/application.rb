require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestCors2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # We want to have each for embed its own authenticity token so when
    # the form is rendered on another site, the token is already
    # in place for us.
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options], credentials: true
      end
    end

    # Log to STDOUT for Docker purposes
    config.logger    = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  end
end
