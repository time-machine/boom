# coding: utf-8

# Platform is a centralized point to shell out platform specific functionality
# like clipboard access or commands to open URLs.
#
# Clipboard is a centralized point to shell out to each individual platform's
# clipboard, pasteboard, or whatever they decide to call it.
module Boom
  class Platform
    class << self
      include Boom::Color

      # Public: Tests if currently running on darwin.
      #
      # Returns true if running on darwin (MacOS X), else false.
      def darwin?
        !!(RUBY_PLATFORM =~ /darwin/)
      end

      # Public: Tests if currently running on windows.
      #
      # Apparently Windows RUBY_PLATFORM can be 'win32' or 'mingw32'.
      #
      # Returns true if running on windows (win32/mingw32), else false.
      def windows?
        !!(RUBY_PLATFORM =~ /win32/) || !!(RUBY_PLATFORM =~ /mingw32/)
      end

      # Public: Returns the command used to open a file or URL for the current
      # platform.
      #
      # Currently only supports MacOS X and Linux with `xdg-open`
      #
      # Returns a String with the bin.
      def open_command
        # there must be a nicer way of doing this?
        if darwin?
          'open'
        else
          windows? ? 'start' : 'xdg-open'
        end
      end

      # Public: Opens a given Item's value in the browser. This method is
      # designed to handle multiple platforms.
      #
      # Returns a String explaining what was done.
      def open(item)
        unless windows?
          `#{open_command} '#{item.url.gsub("\'", "\\'")}'`
        else
          `#{open_command} #{item.url.gsub("\'", "\\'")}`
        end

        "#{magenta("Boom!")} We just opened \"#{yellow(item.value)}\" for you."
      end

      # Public: Returns the command used to copy a given Item's value to the
      # clipboard for the current platform.
      #
      # Returns a String with the bin.
      def copy_command
        darwin? ? 'pbcopy' : 'xclip -selection clipboard'
      end

      # Public: Copies a give Item's value to the clipboard. This method is
      # designed to handle multiple platforms.
      #
      # Returns a String explaining what was done.
      def copy(item)
        Kernel.system("printf '#{item.value.gsub("\'", "\\'")}' | #{copy_command}")
        "#{magenta("Boom!")} We just copied \"#{yellow(item.value)}\" to your clipboard."
      end
    end
  end
end
