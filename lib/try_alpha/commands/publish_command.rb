module TryAlpha
  module Commands
    class PublishCommand < BaseCommand
      desc '[TEMPLATE_FILE]', 'Publish a template'
      long_desc 'Publish the specified compiled template to the Alpha marketplace'

      def initialize(template_file_path = nil, options: {})
        @template_file_path = template_file_path
        super
      end

      def run
        raise MissingArgumentError, 'You must provide a template file' unless template_file_path

        with_valid_credentials do
          publish_template
          done
        end
      end

      private

      attr_reader :template_file_path

      def publish_template
        response = api_client.publish_template(template_file_path)

        raise PublishTemplateError, response unless response.success?

        @template = response.parsed_body
      end

      def done
        say('Template published successfully!', :green)
      end
    end
  end
end
