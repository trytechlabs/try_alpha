module TryAlpha
  module Commands
    class BaseCommand
      include Thor::Actions
      include Thor::Shell

      class << self
        attr_reader :usage, :description, :long_description, :multi_options, :single_options

        def run(...)
          new(...).run
        end

        def command_name
          name.demodulize.underscore.gsub(/_command$/, '')
        end

        def desc(usage_or_description, description = nil)
          @description = description.nil? ? usage_or_description : description
          @usage = description.nil? ? nil : usage_or_description
        end

        def long_desc(long_description)
          @long_description = long_description
        end

        def options(**options)
          @multi_options = options
        end

        def option(name, **options)
          @single_options ||= {}
          @single_options[name] = options
        end

        def inject!(cli)
          command_klass = self
          prepare(cli)

          cli.define_method(command_name) do |*args|
            command_klass.run(*args, options:)
          rescue ClientError => e
            say_error('[FATAL] ', :red) && say(e.message.strip) && say
          rescue Interrupt
            nil
          end
        end

        def prepare(cli)
          cli.desc([command_name, usage].flatten.join(' '), description)
          cli.long_desc(long_description) if long_description
          cli.options(multi_options) if multi_options.present?
          single_options&.each { |name, opts| cli.option(name, opts) }
        end
      end

      def initialize(*_args, options: {})
        @options = options
      end

      def run = raise NotImplementedError

      private

      attr_reader :options

      def space = say

      def with_valid_credentials
        return say('You need to login. Please, run `alpha init` first.') unless valid_credentials?

        yield
      end

      def valid_credentials?
        api_client.organization_slug.present? && api_client.organization.success?
      end

      def api_client
        @api_client ||= API::Client.new
      end
    end
  end
end
