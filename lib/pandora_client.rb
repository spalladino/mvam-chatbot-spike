require 'uri'

class PandoraClient

  attr_reader :config

  BASE_URL = 'https://aiaas.pandorabots.com'

  def initialize(config)
    @config = config
  end

  def talk(input, session_id = '')
    query = URI.encode_www_form(input: input, sessionid: session_id, user_key: config.get_pandora_user_key)
    request_uri = "/talk/#{config.get_pandora_app_id}/#{config.get_pandora_bot_name}?#{query}"
    post = Net::HTTP::Post.new(request_uri)
    response = https.request(post)
    raise "Invalid request" if response.code != '200'
    return JSON.parse(response.body)
  end

  private

  def https
    uri = URI(BASE_URL)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https
  end

end
