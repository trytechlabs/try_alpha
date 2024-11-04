module TryAlpha
  class Banner
    def self.display
      puts "\e[31m"
      puts banner
      puts "\e[0m"
    end

    # rubocop:disable Metrics/AbcSize
    def self.banner
      "#{b} _______            #{w}          _         _                 \n" \
        "#{b}|__   __|           #{w}   /\\    | |       | |               \n" \
        "#{b}   | | _ __  _   _  #{w}  /  \\   | | _ __  | |__    __ _     \n" \
        "#{b}   | || '__|| | | | #{w} / /\\ \\  | || '_ \\ | '_ \\  / _` | \n" \
        "#{b}   | || |   | |_| | #{w}/ ____ \\ | || |_) || | | || (_| |    \n" \
        "#{b}   |_||_|    \\__, |#{w}/_/    \\_\\|_|| .__/ |_| |_| \\__,_| \n" \
        "#{b}              __/ | #{w}            | |                       \n" \
        "#{b}             |___/  #{w}            |_|#{version}             \n" \
        "#{w}\n#{copyright}#{reset}\n"
    end
    # rubocop:enable Metrics/AbcSize

    def self.r
      @r ||= "\e[1;31m"
    end

    def self.b
      @b ||= "\e[30m"
    end

    def self.w
      "\e[1;37m"
    end

    def self.reset
      @b = @r = nil
      "\e[0m"
    end

    def self.version
      "#{b}v. #{w}#{TryAlpha::VERSION}".rjust(30)
    end

    def self.copyright
      " #{r}Copyright © 2024  TryTechLabs#{w} ".rjust(56, '-').ljust(67, '-')
    end
  end
end
