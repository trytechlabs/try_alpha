module TryAlpha
  class Compiler
    def self.compile(...)
      new(...).compile
    end

    def initialize(path, payload)
      @path = path
      @payload = payload
    end

    def compile
      ERB.new(payload).result(binding)
    rescue StandardError => e
      raise ClientError, "Failed to compile template: #{e.message}"
    end

    protected

    def include_file(template_path) = do_include(:file, template_path)
    def include_initializer(template_path) = do_include(:initializer, template_path)
    def include_lib(template_path) = do_include(:lib, template_path)
    def include_vendor(template_path) = do_include(:vendor, template_path)

    private

    attr_reader :path, :payload

    def do_include(method, file_path)
      file_contents = File.read(File.join(path, file_path)).strip

      "#{method} #{file_path}, <<-CODE\n#{file_contents}\nCODE\n"
    end
  end
end
