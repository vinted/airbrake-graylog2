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

        if notice.url ||
            notice.controller ||
            notice.action ||
            !notice.parameters.blank? ||
            !notice.cgi_data.blank? ||
            !notice.session_data.blank?

          message << "\n"
          message << "-------------------------------\n"
          message << "Request:\n"
          message << "-------------------------------\n\n"

          message << "Url: " + notice.request.url.to_s + "\n"
          message << "Controller: " + notice.request.controller.to_s + "\n"
          message << "Action: " + notice.request.action.to_s + "\n"

          unless notice.parameters.nil? || notice.parameters.empty?
            message << "Parameters: " + notice.parameters.to_s + "\n"
          end

          unless notice.session_data.nil? || notice.session_data.empty?
            message << "Session: " + notice.session_data.to_s + "\n"
          end

          unless notice.cgi_data.nil? || notice.cgi_data.empty?
            message << "CGI data: " + notice.cgi_data.to_s + "\n"
          end

        end

        message << "\n"
        message << "-------------------------------\n"
        message << "Server environment:\n"
        message << "-------------------------------\n\n"
        message << "Project root: " + notice.project_root.to_s + "\n"
        message << "Environment name: " + notice.environment_name.to_s + "\n"
        message << "Hostname: " + notice.hostname.to_s + "\n"
        message << "Process: " + $$.to_s + "\n"

      end

    end
  end
end