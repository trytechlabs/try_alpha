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

      def publish_template(template_file_path)
        payload = { file: HTTP::FormData::File.new(template_file_path) }

        request(:post, '/templates', payload, using: :form)
      end

      private

      def request(verb, resource, payload = {}, **options)
        uri = [TryAlpha.api_url, resource].join
        using = options.fetch(:using, :json)
        headers = default_headers(using).merge(options.fetch(:headers, {}))
        response = HTTP::Client.new.request(verb, uri, using => payload, headers:)

        Response.new(status: response.status, body: response.body)
      rescue HTTP::Error => e
        raise ConnectionError, e.message
      end

      def default_headers(using)
        { 'Authorization' => "Bearer #{token}" }.tap do |headers|
          headers['Content-Type'] = 'application/json' if using == :json
        end
      end

      def config
        @config ||= Config.load
      end
    end
  end
end
