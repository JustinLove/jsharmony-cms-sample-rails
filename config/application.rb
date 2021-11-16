require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'js_harmony_cms'
require "js_harmony_cms/middleware/router"
require "js_harmony_cms/middleware/clientjs_server"

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

    config.x.jsHarmonyCMS.access_key = "ba9294f7eddc7880a2cfedd7559cca2faf26592eed769ce1d42cbbf3d27a9077a960493d6f58973b74f83c5d277579bb"
    config.x.jsHarmonyCMS.content_path = 'public/testcases'
    config.x.jsHarmonyCMS.cms_server_urls = ['https://localhost:8081/']
    config.x.jsHarmonyCMS.cms_clientjs_editor_launcher_path = '/.jsHarmonyCms/jsHarmonyCmsEditor.js'

    config.middleware.insert_before ActionDispatch::Static, JsHarmonyCms::Middleware::Router, config.x.jsHarmonyCMS.content_path+'/jshcms_redirects.json'
    config.middleware.insert_before ActionDispatch::Static, JsHarmonyCms::Middleware::ClientjsServer, config.x.jsHarmonyCMS.cms_clientjs_editor_launcher_path

  end
end
