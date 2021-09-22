require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative "../lib/cms_router_middleware"

module RailsJsh
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.middleware.insert_before ActionDispatch::Static, CmsRouterMiddleware, 'public/cms/jshcms_redirects.json'
    config.middleware.insert_after ActionDispatch::Static, ActionDispatch::Static, 'public/cms'

    config.x.jsHarmonyCMS.access_key = "c982cd413bf2a53bb082356c304472814a9af9b51a3de64e29079d941c092360554ae1bffa653eb8ac83a3459fc54806"
  end
end
