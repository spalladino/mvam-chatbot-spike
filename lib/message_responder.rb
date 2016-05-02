require './models/user'
require './models/message_log'
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
    pandora_talk("XSET name #{user.name}") if user.created_record || user.message_logs.order(:id).last.created_at < 1.hour.ago
    MessageLog.create_at(user_id: user.id, text: message.text)

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

  def pandora_talk(text)
    PandoraClient.new(@config).talk(text, session_id: user.uid, client_name: user.uid)
  end

  def answer_with_message(text)
    if text.include?("XKEYBOARD")
      text, keyboard = text.split('XKEYBOARD').map(&:strip)
      answers = keyboard.split('XSPLITTER').map(&:strip)
    end

    MessageSender.new(bot: bot, chat: message.chat, text: text, user_id: user.id, answers: answers).send
  end
end
