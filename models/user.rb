require 'active_record'

class User < ActiveRecord::Base

  attr_accessor :created_record

  has_many :message_logs

end
