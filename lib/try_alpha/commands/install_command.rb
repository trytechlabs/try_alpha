module TryAlpha
  module Commands
    class InstallCommand < BaseCommand
      desc '[TEMPLATE_NAME]', 'Installs a template'
      long_desc 'Installs the specified template from the TryAlpha registry'
      option :yes, type: :boolean, desc: 'Skip confirmation prompt'

      def initialize(template_name = nil, options: {})
        @template_name = template_name
        super
      end

      def run
        raise MissingArgumentError, 'You must provide a template name' unless template_name

        with_valid_credentials do
          fetch_template
          install_confirmed? ? install_template : say('Aborted...')
        end
      end

      private

      attr_reader :template_name, :template

      def fetch_template
        response = api_client.template(template_name)

        raise TemplateNotFoundError, template_name unless response.success?

        @template = response.parsed_body
      end

      def install_confirmed?
        return true if options[:yes].present?

        confirm = ask('Are you sure you want to install this template? [Y/n]', default: 'Y')

        confirm.to_s.upcase == 'Y'
      end

      def install_template
        with_template_file do |file|
          say("Installing #{template_name}...", :green)
          runner = RailsTemplateRunner.run(file.path)
          say(runner.output)
          raise InstallTemplateError, template_name unless runner.success?

          say("Template #{template_name} installed successfully!", :green)
        end
      end

      def with_template_file
        Tempfile.new([template_name, '.rb']).tap do |file|
          file.write(template[:content])
          file.rewind

          yield(file)

          file.close
          file.unlink
        end
      end
    end
  end
end
