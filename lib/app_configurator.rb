require 'logger'

require './lib/database_connector'

class AppConfigurator
  def configure
    setup_i18n
    setup_database
  end

  def get_token
    @@bot_token ||= get_secret 'telegram_bot_token'
  end

  def get_pandora_app_id
    @@pandora_app_id ||= get_secret 'pandora_app_id'
  end

  def get_pandora_user_key
    @@pandora_user_key ||= get_secret 'pandora_user_key'
  end

  def get_pandora_bot_name
    @@pandora_bot_name ||= get_secret 'pandora_bot_name'
  end

  def get_logger
    Logger.new(STDOUT, Logger::DEBUG)
  end

  private

  def get_secret(key)
    secrets[key] || ENV[key.upcase] || (raise "Setting #{key} was not found in secrets.yml or among environment variables")
  end

  def secrets
    @@secrets ||= (YAML::load(IO.read('config/secrets.yml')) rescue {})
  end

  def setup_i18n
    I18n.load_path = Dir['config/locales.yml']
    I18n.locale = :en
    I18n.backend.load_translations
  end

  def setup_database
    DatabaseConnector.establish_connection
  end
end
