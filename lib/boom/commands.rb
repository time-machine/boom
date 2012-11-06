module Boom
  class Commands
    class << self
      attr_accessor :storage

      def execute(storage, args)
        @storage = storage
        command = args.shift

        return list unless command

        send(command) if respond_to?(command)
        search(command)
      end

      # Public: add a new Item to a list.
      #
      # list  - The String name of the List to associate with this Item.
      # name  - The String name of the Item
      # value - The String value of the Item
      #
      # Example
      #
      #   Commands.add("snippets", "sig", "-@holman")
      #
      # Returns the newly created Item.
      def add
      end

      # Public: search for an Item in all lists by name. Drops the
      # corresponding entry into your clipboard.
      #
      # name - The String term to search for in all Item names.
      #
      # Returns the matching Item.
      def search(name)
        item = storage.items.detect do |item|
          item.name == name
        end

        Clipboard.copy item
      end

      # Public: prints a tidy overview of your Lists in descending order of
      # number of Items.
      #
      # Returns nothing.
      def list
        storage.lists.each do |list|
          puts "  #{list.name} (#{list.items.size})"
        end
      end
    end
  end
end
