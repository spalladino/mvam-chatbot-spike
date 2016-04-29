require './models/user'
require './lib/message_sender'
require './lib/pandora_client'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user
  attr_reader :config

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @config = options[:config]
    @user = User.find_or_create_by(uid: message.from.id) do |u|
      u.created_record = true
      u.name = [message.from.first_name, message.from.last_name].compact.join(' ')
      u.username = message.from.username
    end
  end

  def respond
    initialize_user if user.created_record
    response = pandora_talk(message.text)
    @config.get_logger.debug("Pandorabot: #{response.inspect}")
    answer_with_message(response['responses'].join(". ").to_s) if response
  rescue => ex
    @config.get_logger.error("Error processing message #{message.inspect} from #{user.inspect}: #{ex}")
  end

  private

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
      when 0
        yield
      when 1
        yield $1
      when 2
        yield $1, $2
      end
    end
  end

  def initialize_user
    pandora_talk("XSET name #{user.name}")
  end

  def pandora_talk(text)
    PandoraClient.new(@config).talk(text, session_id: user.uid, client_name: user.uid)
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
