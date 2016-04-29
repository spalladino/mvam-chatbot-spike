require './lib/reply_markup_formatter'
require './lib/app_configurator'
require './models/message_log'

class MessageSender
  attr_reader :bot
  attr_reader :text
  attr_reader :chat
  attr_reader :answers
  attr_reader :logger
  attr_reader :user_id

  def initialize(options)
    @bot = options[:bot]
    @text = options[:text]
    @chat = options[:chat]
    @answers = options[:answers]
    @reply_markup = options[:reply_markup]
    @user_id = options[:user_id]
    @logger = AppConfigurator.new.get_logger
  end

  def send
    if reply_markup
      bot.api.send_message(chat_id: chat.id, text: text, reply_markup: reply_markup)
    else
      bot.api.send_message(chat_id: chat.id, text: text)
    end

    logger.debug "sending '#{text}' to #{chat.username}"
    MessageLog.create_ao(user_id: user_id, text: text)
  end

  private

  def reply_markup
    if @reply_markup
      @reply_markup
    elsif answers
      ReplyMarkupFormatter.new(answers).get_markup
    end
  end
end
