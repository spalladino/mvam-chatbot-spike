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
    @user = User.find_or_create_by(uid: message.from.id)
  end

  def respond
    response = PandoraClient.new(@config).talk(message.text, user.uid.to_s)
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

  def answer_with_greeting_message
    answer_with_message I18n.t('greeting_message')
  end

  def answer_with_farewell_message
    answer_with_message I18n.t('farewell_message')
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
