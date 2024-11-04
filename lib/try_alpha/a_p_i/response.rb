module TryAlpha
  module API
    Response = Struct.new(:status, :body, keyword_init: true) do
      def success?
        status.between?(200, 299)
      end

      def parsed_body
        JSON.parse(body, symbolize_names: true)
      rescue JSON::ParserError
        {}
      end
    end
  end
end
