module Boom
  class Clipboard
    class << self
      # Public: Copies a give Item's value to the clipboard. This method is
      # designed to handle multiple platforms.
      #
      # Returns nothing.
      def copy(item)
        clipboard = ''

        if RUBY_PLATFORM =~ /darwin/
          clipboard = 'pbcopy' # Mac
        else
          # clipboard = 'xclip -sel clip' # Linux
        end

        `echo '#{item.value}' | tr -d "\n" | #{clipboard}`

        "Boom! We just copied #{item.value} to your clipboard."
      end
    end
  end
end
