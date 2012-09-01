require "airbrake"
require "airbrake-graylog2/configuration"
require "airbrake-graylog2/sender"
require "airbrake-graylog2/version"

Airbrake.instance_eval do

  def configure_with_graylog2(*args, &block)
    configure_without_graylog2(*args, &block).tap do
      self.sender = Airbrake::Graylog2::Sender.new(configuration)
    end
  end

  class << self

    alias_method :configure_without_graylog2, :configure
    alias_method :configure, :configure_with_graylog2

    def configuration
      @configuration ||= Airbrake::Graylog2::Configuration.new
    end

    private

    def send_notice(notice)
      if configuration.public?
        sender.send_to_graylog2(notice)
      end
    end

  end

end