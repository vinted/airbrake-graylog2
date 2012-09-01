require 'gelf'

module Airbrake
  module Graylog2
    class Sender

      def initialize(configuration)
        @configuration = configuration
        @notifier = GELF::Notifier.new(configuration.host, configuration.port, configuration.graylog2_max_size, {
          :facility => configuration.graylog2_facility
        })
      end

      def send_to_graylog2(notice)
        args = {
          :short_message => notice.error_message,
          :full_message => convert_airbrake_notice_to_text(notice)
        }

        @notifier.notify!(args)
      end

      private

      def convert_airbrake_notice_to_text(notice)
        message = ""
        message << "-------------------------------\n"
        message << "Error details:\n"
        message << "-------------------------------\n\n"
        message << "Error class: " + notice.error_class + "\n"

        message << "\n"
        message << "-------------------------------\n"
        message << "Backtrace:\n"
        message << "-------------------------------\n\n"
        message << notice.backtrace.lines.join("\n")

        message << "\n"
        message << "-------------------------------\n"
        message << "Server environment:\n"
        message << "-------------------------------\n\n"
        message << "Project root: " + notice.project_root.to_s + "\n"
        message << "Environment name: " + notice.environment_name.to_s + "\n"
        message << "Hostname: " + notice.hostname.to_s + "\n"

      end

    end
  end
end