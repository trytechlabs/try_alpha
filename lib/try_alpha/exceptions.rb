module TryAlpha
  ClientError = Class.new(StandardError)
  InitFailedError = Class.new(ClientError)
  ConnectionError = Class.new(ClientError)
  MissingArgumentError = Class.new(ClientError)

  TemplateNotFoundError = Class.new(ClientError) do
    def initialize(template_name)
      super("Template '#{template_name}' not found")
    end
  end

  InstallTemplateError = Class.new(ClientError) do
    def initialize(template_name)
      super("Failed to install template '#{template_name}'")
    end
  end

  PublishTemplateError = Class.new(ClientError) do
    def initialize(response)
      super("Failed to publish template: #{response.errors.join(', ')}")
    end
  end
end
