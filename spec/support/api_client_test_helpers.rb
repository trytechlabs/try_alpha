
require 'rspec'
require 'try_alpha'

module TryAlpha
  module API
    module ClientTestHelpers
      class StubbedClient
        delegate :double, to: :evaluator

        def initialize(evaluator, traits, options)
          @evaluator = evaluator
          @traits = [:base_trait, traits].flatten.compact
          @options = options || {}
        end

        def to_h
          traits.each_with_object({}) do |trait, hash|
            hash.merge!(send(trait))
          end.merge(options)
        end

        private

        attr_reader :evaluator, :traits, :options

        def base_trait
          { organization_slug: 'fake_slug',
            token: 'fake_token',
            organization: double(:organization, success?: false),
            templates: double(:templates, success?: false),
            template: double(:template, success?: false) }
        end

        def with_valid_credentials
          { organization: double(:organization, success?: true) }
        end

        def with_found_template
          { template: double(:template,
                             success?: true,
                             parsed_body: { content: 'Rails templating command stub'} ) }
        end

        def with_found_invalid_template
          { template: double(:template,
                             success?: true,
                             parsed_body: { content: 'TEMPLATE-ERROR'} ) }
        end
      end

      def stub_api_client!(*traits, **options)
        stubbed_client = StubbedClient.new(self, traits, options)

        instance_double(Client, stubbed_client.to_h).tap do |api_client|
          allow(Client).to receive(:new).and_return(api_client)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include TryAlpha::API::ClientTestHelpers
end
