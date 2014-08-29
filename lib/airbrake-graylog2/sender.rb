require 'gelf'
require 'active_support/core_ext/object/blank'

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
          :full_message => convert_airbrake_notice_to_text(notice),
          :level => @configuration.graylog2_level
        }

        extra_args = @configuration.graylog2_extra_args.merge({
          :environment => notice.environment_name,
          :pid => Process.pid
        })

        extra_args.each do |name, value|
          args["_#{name}"] = value unless value.nil?
        end

        @notifier.notify!(args)
      end

      private

      def convert_airbrake_notice_to_text(notice)
        message = ""
        message << "Error class: " + notice.error_class.to_s + "\n"
        message << "Project root: " + notice.project_root.to_s + "\n"
        message << "Environment name: " + notice.environment_name.to_s + "\n"
        message << "Hostname: " + notice.hostname.to_s + "\n"
        message << "Process: " + $$.to_s + "\n"

        message << "\n"
        message << "-------------------------------\n"
        message << "Backtrace:\n"
        message << "-------------------------------\n\n"
        message << cleanup_backtrace(notice.exception).join("\n")

        if notice.url ||
            notice.controller ||
            notice.action ||
            !notice.parameters.blank? ||
            !notice.cgi_data.blank? ||
            !notice.session_data.blank?

          message << "\n\n"
          message << "-------------------------------\n"
          message << "Request:\n"
          message << "-------------------------------\n"
          message << "\n"
          message << "Url: " + notice.url.to_s + "\n"
          message << "Controller: " + notice.controller.to_s + "\n"
          message << "Action: " + notice.action.to_s + "\n"

          unless notice.parameters.nil? || notice.parameters.empty?
            message << "\n"
            message << "Parameters:\n\n" + notice.parameters.to_s + "\n"
          end

          unless notice.session_data.nil? || notice.session_data.empty?
            message << "\n"
            message << "Session:\n\n" + notice.session_data.to_s + "\n"
          end

          unless notice.cgi_data.nil? || notice.cgi_data.empty?
            message << "\n"
            message << "CGI data:\n\n"

            notice.cgi_data.each do |key, val|
              message << "#{key} => #{val}\n"
            end
          end

        end

        message
      end

      def cleanup_backtrace(exception)
        trace = exception && exception.backtrace ? exception.backtrace : caller
        return trace unless defined?(::Rails) && defined?(::Rails.backtrace_cleaner)

        ::Rails.backtrace_cleaner.clean(trace)
      end
    end
  end
end
