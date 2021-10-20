require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative "../lib/cms_router_middleware"
require_relative "../lib/cms_clientjs_middleware"

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

    # sample test
    if false
      config.x.jsHarmonyCMS.access_key = "c982cd413bf2a53bb082356c304472814a9af9b51a3de64e29079d941c092360554ae1bffa653eb8ac83a3459fc54806"
      config.x.jsHarmonyCMS.content_path = 'public/cms'
      config.x.jsHarmonyCMS.cms_server_urls = ['https://localhost:8081/']
      config.x.jsHarmonyCMS.cms_clientjs_editor_launcher_path = '/.jsHarmonyCms/jsHarmonyCmsEditor.js'
    end

    # test cases
    if true
      config.x.jsHarmonyCMS.access_key = "ba9294f7eddc7880a2cfedd7559cca2faf26592eed769ce1d42cbbf3d27a9077a960493d6f58973b74f83c5d277579bb"
      config.x.jsHarmonyCMS.content_path = 'public/testcases'
      config.x.jsHarmonyCMS.cms_server_urls = ['https://localhost:8081/']
      config.x.jsHarmonyCMS.cms_clientjs_editor_launcher_path = '/.jsHarmonyCms/jsHarmonyCmsEditor.js'
    end

    config.middleware.insert_before ActionDispatch::Static, CmsRouterMiddleware, config.x.jsHarmonyCMS.content_path+'/jshcms_redirects.json'
    config.middleware.insert_before ActionDispatch::Static, CmsClientjsMiddleware, config.x.jsHarmonyCMS.cms_clientjs_editor_launcher_path
    config.middleware.insert_after ActionDispatch::Static, ActionDispatch::Static, config.x.jsHarmonyCMS.content_path

  end
end
