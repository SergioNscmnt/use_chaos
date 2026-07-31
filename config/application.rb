require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UseChaos
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # A versão de libvips disponível no ambiente não oferece o modo seguro
    # exigido pelo Rails 8.1 para conteúdo enviado por usuários.
    config.active_storage.variant_processor = :mini_magick

    config.i18n.default_locale = :"pt-BR"
    config.i18n.available_locales = [ :"pt-BR" ]
    config.i18n.fallbacks = true
    config.time_zone = ENV.fetch("FUSO_HORARIO", "America/Porto_Velho")
    config.active_record.default_timezone = :utc
  end
end
