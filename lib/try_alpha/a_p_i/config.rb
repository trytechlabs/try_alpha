module TryAlpha
  module API
    CONFIG_FILE_DIR = '.alpha'.freeze
    CONFIG_FILE_NAME = 'config.yml'.freeze
    CONFIG_FILE_PATH = "#{CONFIG_FILE_DIR}/#{CONFIG_FILE_NAME}".freeze

    Config = Struct.new(:token, :organization_slug, keyword_init: true) do
      def self.load
        new(YAML.load_file(CONFIG_FILE_PATH) || {})
      rescue Errno::ENOENT
        new
      end

      def update_config!(**attributes)
        attributes.each { |key, value| public_send(:"#{key}=", value) }

        create_dirs && save_config
      end

      private

      def create_dirs
        CONFIG_FILE_DIR.split('/').each_with_object('') do |dir, path|
          path += "#{dir}/"
          FileUtils.mkdir_p(path)
        end
      end

      def save_config
        File.write(CONFIG_FILE_PATH, as_json.deep_symbolize_keys.to_yaml)
      end
    end
  end
end
