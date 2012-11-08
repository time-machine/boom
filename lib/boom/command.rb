module Boom
  class Command
    class << self
      attr_accessor :storage

      def execute(storage, *args)
        @storage = storage
        command = args.shift

        return overview unless command

        return send(command, *args) if respond_to?(command)
        search(command)
      end

      # Public: Adds a new List or Item, depending upon context.
      #
      # list  - The String List name.
      # name  - The String name of the Item (optional).
      # value - The String value of the Item (optional).
      #
      # Example
      #
      #   Commands.add("snippets", "sig", "- @holman")
      #   Commands.add("snippets")
      #
      # Returns the newly created List or Item.
      def add(list, name=nil, value=nil)
        if value
          add_item(list, name, value)
        else
          add_list(list)
        end

        storage.save!
      end

      # Public: Add a new Item to a list.
      #
      # list  - The String name of the List to associate with this Item.
      # name  - The String name of the Item.
      # value - The String value of the Item.
      #
      # Example
      #
      #   Commands.add_item("snippets", "sig", "- @holman")
      #
      # Returns the newly created Item.
      def add_item(list, name, value)
        list = storage.lists.find { |storage_list| storage_list.name == list }
        list.add_item(Item.new(name, value))
        puts "Boom! \"#{name}\" in \"#{list.name}\" is \"#{value}\". Got it."
      end

      # Public: Add a new List.
      #
      # name - The String name of the List.
      #
      # Example
      #
      #   Commands.add_list("snippets")
      #
      # Returns the newly created List.
      def add_list(name)
        lists = (storage.lists << List.new(name))
        storage.lists = lists
        puts "Boom! Created a new list called \"#{name}\"."
      end

      # Public: Deletes an Item or List, depending upon context.
      #
      # target - Either "list" or the Item name.
      # name   - The String name of the List to delete (optional).
      #
      # Example
      #
      #   Commands.delete("list", "snippets")
      #   Commands.delete("test-item")
      #
      # Returns the newly created List or Item.
      def delete(target, name=nil)
        if target == 'list'
          delete_list(name)
        else
          delete_item(target)
        end

        storage.save!
      end

      # Public: Remove a named List.
      #
      # name - The String name of the List.
      #
      # Example
      #
      #   Commands.delete_list("snippets")
      #
      # Returns nothing.
      def delete_list(name)
        lists = storage.lists.reverse.reject { |list| list.name == name }
        storage.lists = lists
        puts "Boom! Deleted the \"#{name}\" list."
      end

      # Public: Remove a named Item.
      #
      # name - The String name of the Item.
      #
      # Example
      #
      #   Commands.delete_item("an-item-name")
      #
      # Returns nothing.
      def delete_item(name)
        storage.lists = storage.lists.each do |list|
          list.items.reject! { |item| item.name == name }
        end
        puts "Boom! \"#{name}\" is gone forever."
      end

      # Public: Search for an Item in all lists by name. Drops the
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

      # Public: Prints a tidy overview of your Lists in descending order of
      # number of Items.
      #
      # Returns nothing.
      def overview
        storage.lists.each do |list|
          puts "  #{list.name} (#{list.items.size})"
        end
      end

      # Public: Prints all Items over all Lists
      #
      # Returns nothing.
      def list
        storage.lists.each do |list|
          puts "  #{list.name}"
          list.items.each do |item|
            puts "    #{item.name}: #{item.value}"
          end
        end
      end
    end
  end
end