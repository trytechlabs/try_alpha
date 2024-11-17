require 'open3'

module TryAlpha
  class RailsTemplateRunner
    Result = Struct.new(:success, :output, keyword_init: true) do
      def success?
        success
      end
    end

    def self.run(location)
      new(location).run
    end

    def initialize(location)
      @location = location
    end

    def run
      Open3.popen3(*command) do |_stdin, stdout, stderr, wait_thread|
        output = stdout.read
        error = stderr.read
        success = wait_thread.value.success?

        Result.new(success:, output: output + error)
      end
    end

    private

    attr_reader :location

    def command
      "bundle exec bin/rails app:template LOCATION=#{location}"
    end
  end
end
