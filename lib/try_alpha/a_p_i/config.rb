module TryAlpha
  module API
    CONFIG_FILE_DIR = '.alpha'.freeze

    Config = Struct.new(:token, :organization_slug, keyword_init: true) do
      def self.config_file_path
        file_name = ENV['ALPHA_MODE'] == 'development' ? 'dev-config.yml' : 'config.yml'
        File.join(CONFIG_FILE_DIR, file_name)
      end

      def self.load
        new(YAML.load_file(config_file_path) || {})
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
        File.write(self.class.config_file_path, as_json.deep_symbolize_keys.to_yaml)
      end
    end
  end
end
