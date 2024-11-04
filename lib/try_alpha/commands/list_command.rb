module TryAlpha
  module Commands
    class ListCommand < BaseCommand
      desc '[TERM]', 'List available templates matching the search term'

      def initialize(search_term = nil, options: {})
        @search_term = search_term
        super
      end

      def run
        raise MissingArgumentError, 'You must provide a search term' if search_term.blank?

        with_valid_credentials do
          templates = api_client.templates(search_term).parsed_body

          templates.blank? ? no_templates_found : list(templates)
        end
      end

      private

      attr_reader :search_term

      def no_templates_found
        say('No templates found matching the search term.')
      end

      def list(templates)
        say("Templates found for _#{search_term}_:")

        templates.each do |template|
          say(['*', template[:slug].ljust(35), template[:description]].join(' '))
        end
      end
    end
  end
end
