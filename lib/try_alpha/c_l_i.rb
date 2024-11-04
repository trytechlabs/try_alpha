module TryAlpha
  class CLI < Thor
    include Thor::Actions

    def self.exit_on_failure?
      true
    end

    def help(*)
      Banner.display

      super
    end

    [Commands::AddCommand,
     Commands::CompileCommand,
     Commands::InitCommand,
     Commands::ListCommand].map { |command| command.inject!(self) }
  end
end
