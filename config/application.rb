require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cosmos
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil
    # assets precompileを無効化します。
    # see:https://qiita.com/Tak0325/items/efce14f67eb572d8742e
    config.assets.enabled = false
    config.i18n.default_locale = :ja
    # rspecのgenerator設定 request_spec, model_spec だけ書くので、それ以外はfalse see: https://qiita.com/Ushinji/items/522ed01c9c14b680222c
    config.generators do |g|
      g.test_framework :rspec,
            view_specs: false,
            helper_specs: false,
            controller_specs: false,
            routing_specs: false
    end

    config.time_zone = 'Tokyo'

    # Railsが自動で挿入するエラータグを非表示とする
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
