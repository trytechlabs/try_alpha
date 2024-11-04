module TryAlpha
  module API
    class Client
      delegate :token, :organization_slug, :update_config!, to: :config

      def organization
        request(:get, '/organization')
      end

      def templates(name_or_slug_cont)
        request(:get, '/templates', name_or_slug_cont:)
      end

      def template(slug)
        request(:get, "/templates/#{slug}")
      end

      private

      def request(verb, resource, payload = {}, headers = {})
        uri = [TryAlpha.api_url, resource].join
        headers = default_headers.merge(headers)

        response = HTTP::Client.new.request(verb, uri, json: payload, headers:)

        Response.new(status: response.status, body: response.body)
      rescue HTTP::Error => e
        raise ConnectionError, e.message
      end

      def default_headers
        { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' }
      end

      def config
        @config ||= Config.load
      end
    end
  end
end
