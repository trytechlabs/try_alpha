module TryAlpha
  module Commands
    class CompileCommand < BaseCommand
      TEMPLATE_ATTRIBUTES = %i[name slug version description content tags].freeze

      desc '[CONFIG_FILENAME]', 'Compile a template to allow publish it in the Alpha marketplace'
      long_desc <<-LONGDESC
        This command will compile a template to allow publish it in the Alpha marketplace.

        To compile a template you need to provide a configuration file, which is a YAML file
        that contains the necessary information to compile the template. The configuration file
        should be structured as follows:

        ```yaml\n
        name: 'My Template'\n
        version: '1.0.0'\n
        description: 'A description of my template'\n
        content: |\n
          # Your template content here. You can use the Rails templating commands that will run\n
          # when the template is installed in a Rails application. Please check out the Rails\n
          # templating documentation for more information at\n
          # https://guides.rubyonrails.org/rails_application_templates.html\n
          #\n
          # For example, you can add a gem to the Gemfile:\n
          gem 'my_gem', '~> 1.0'\n
          #\n
          # Or you can add a model to your application:\n
          file 'app/models/my_model.rb', <<~RUBY\n
            class MyModel < ApplicationRecord\n
              # Your model code here\n
            end\n
          RUBY\n
          #\n
          # This configuration file has some extra abilities to help you organize your template:\n
          # - You can use ERB to generate dynamic content in your template. For example:\n
          #\n
          # include_[file/lib/initializer/vendor/rakefile]:\n
          <%= include_file 'app/models/my_model.rb' %>\n
          <%= include_lib 'my_lib.rb' %>\n
          <%= include_initializer 'my_initializer.rb' %>\n
          <%= include_vendor 'my_vendor.rb' %>\n
        ```
      LONGDESC
      option :publish, type: :boolean, default: false, desc: 'Publish the compiled template'

      Template = Struct.new(*TEMPLATE_ATTRIBUTES, keyword_init: true) do
        def slug = name.parameterize
        def version_slug = version.to_s.parameterize

        def dump_encrypted(token)
          cipher = OpenSSL::Cipher.new('AES-256-CBC').encrypt
          cipher.key = Digest::MD5.hexdigest(token)
          output = cipher.update(JSON.pretty_generate(to_h)) + cipher.final

          Base64.encode64(output.unpack1('H*').upcase)
        end
      end

      def initialize(template_config_filename, options: {})
        @template_config_filename = template_config_filename
        @template = Template.new(YAML.load_file(template_config_filename).deep_symbolize_keys)
        super
      end

      def run
        raise MissingArgumentError, 'You must provide a template config file' if template.blank?

        with_valid_credentials do
          process_template_content
          save_compiled_template_file
          done
          publish_template
        end
      end

      private

      attr_reader :template_config_filename, :template

      def process_template_content
        template.content = Compiler.compile(template_path, template.content)
      end

      def save_compiled_template_file
        File.open(compiled_template_file_path, 'w') do |file|
          file.write(template.dump_encrypted(api_client.token))
          file.rewind
          file.close
        end
      end

      def done
        say("Template compiled successfully!", :green)
        say("Template file saved at: #{compiled_template_file_path}")
      end

      def publish_template
        return unless options[:publish]

        PublishCommand.new(compiled_template_file_path).run
      end

      def compiled_template_file_path = [template_path, compiled_filename].join('/')
      def template_path = Pathname.new(template_config_filename).dirname
      def compiled_filename = "#{template.slug}-#{template.version_slug}.alphac"
    end
  end
end
