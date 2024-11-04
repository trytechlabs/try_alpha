module TryAlpha
  module Commands
    class InitCommand < BaseCommand
      desc 'Login to the alpha API to activate it on your project'

      def run
        unless valid_credentials?
          ask_token
          fetch_organization
          save_organization_credentials
        end

        ignore_alpha_files
        all_set
      end

      private

      attr_reader :organization_response

      def ask_token
        say('Logging in to the alpha API...') && space
        token = ask('Enter a valid organization token:')
        api_client.update_config!(token:)
        space
      end

      def fetch_organization
        @organization_response = api_client.organization

        raise InitFailedError, 'Invalid token!' unless organization_response.success?
      end

      def save_organization_credentials
        api_client.update_config!(organization_slug: organization_response.parsed_body[:slug])
        say('Successfully logged in! Welcome back...', :green)
      end

      def ignore_alpha_files
        gitignore = File.read('.gitignore')

        File.open('.gitignore', 'a') do |f|
          f.puts('.alpha') unless gitignore.include?('.alpha')
          f.puts('*.alphac') unless gitignore.include?('*.alphac')
        end
      end

      def all_set
        say('You are all set! Thank you for using the alpha API.')
      end
    end
  end
end
