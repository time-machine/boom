module Boom
  # Color collects some methods for colorizing terminal output.
  module Color
    extend self

    CODES = {
      :reset   => "\e[0m",
      :cyan    => "\e[36m",
      :magenta => "\e[35m",
      :red     => "\e[31m",
      :yellow  => "\e[33m"
    }

    # Tries to enable Windows support if on that platform.
    #
    # Returns nothing.
    def self.included(other)
      if RUBY_PLATFORM =~ /win32/ || RUBY_PLATFORM =~ /mingw32/
        require 'Win32/Console/ANSI'
      end
    rescue LoadError
      # Oh well, we tried.
    end

    # Wraps the given string in ANSI color codes.
    #
    # string     - The String to wrap.
    # color_code - The String representing the ANSI color code.
    #
    # Examples
    #
    #   colorize("Boom!", :magenta)
    #   # => "\e[35mBoom!\e[0m"
    #
    # Returns the wrapped String unless the platform is windows and
    # does not have Win32::Console, in which case, returns the String.
    def colorize(string, color_code)
      if !defined?(Win32::Console) && !!(RUBY_PLATFORM =~ /win32/ || RUBY_PLATFORM =~ /mingw32/)
        # looks like this person doesn't have Win32::Console and is on windows
        # just return the uncolorized string
        return string
      end
      "#{CODES[color_code] || color_code}#{string}#{CODES[:reset]}"
    end

    self.class_eval(CODES.keys.reject { |color| color == :reset }.map do |color|
      "def #{color}(string); colorize(string, :#{color}); end"
    end.join("\n"))
  end
end
