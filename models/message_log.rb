require 'active_record'

class MessageLog < ActiveRecord::Base

  belongs_to :user

  scope :aos, -> { where(application_originated: true) }
  scope :ats, -> { where(application_originated: false) }

  def ao?
    self.application_originated
  end

  def at?
    !self.application_originated
  end

  def self.create_ao(args)
    create(args.merge(application_originated: true))
  end

  def self.create_at(args)
    create(args.merge(application_originated: false))
  end

end
