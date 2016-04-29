require 'uri'

class PandoraClient

  attr_reader :config

  BASE_URL = 'https://aiaas.pandorabots.com'

  def initialize(config)
    @config = config
  end

  def talk(input, session_id: nil, client_name: nil)
    data = { input: input, user_key: config.get_pandora_user_key }
    data[:cient_name] = client_name if client_name
    data[:sessionid] = session_id if session_id
    
    query = URI.encode_www_form(data)
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
