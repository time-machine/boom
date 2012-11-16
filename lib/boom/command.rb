# Command is the main point of entry for boom commands; shell arguments are
# passed through to Command, which then filters and parses through individual
# commands and reroutes them to constituent object classes.
#
# Command also keeps track of one connection to Storage, which is how new data
# changes are persisted to disk. It takes care of any data changes by calling
# Boom::Command#save!.
module Boom
  class Command
    class << self
      # Public: Accesses the in-memory JSON representation.
      #
      # Returns a Storage instance.
      def storage
        Boom.storage
      end

      # Public: Executes a command.
      #
      # args    - The actuall commands to operate on. Can be as few as zero
      #           arguments or as many as three.
      def execute(*args)
        command = args[0]
        major   = args[1]
        minor   = args[2]

        return overview unless command
        delegate(command, major, minor)
      end

      # Public: Prints any given String.
      #
      # s - The String to output
      #
      # Prints to STDOUT and returns. This method exists to standardize output
      # and for easy mocking and overriding.
      def output(s)
        puts(s)
      end

      # Public: Prints a tidy overview of your Lists in descending order of
      # number of Items.
      #
      # Returns nothing.
      def overview
        storage.lists.each do |list|
          output "  #{list.name} (#{list.items.size})"
        end
      end

      # Public: Prints the detailed view of all your Lists and all their
      # Items.
      #
      # Returns nothing.
      def all
        storage.lists.each do |list|
          output "  #{list.name}"
          list.items.each do |item|
            output "    #{item.short_name}:#{item.spacer} #{item.value}"
          end
        end
      end

      # Public: Allows main access to most commands.
      #
      # Returns output based on method calls.
      def delegate(command, major, minor)
        return all  if command == 'all'
        return edit if command == 'edit'
        return help if command == 'help'
        return help if command[0] == '-' # any - dash options are please for help

        # if we're operating on a List
        if storage.list_exists?(command)
          return delete_list(command) if major == 'delete'
          return detail_list(command) unless major
          unless minor == 'delete'
            # minor ||= $stdin.read
            return add_item(command, major, minor) if minor.to_s.length > 0
            return search_list_for_item(command, major)
          end
        end

        return search_items(command) if storage.item_exists?(command)

        if minor == 'delete' and storage.item_exists?(major)
          return delete_item(command, major)
        end

        return create_list(command)
      end

      # Public: Prints all Items over a List.
      #
      # name - The List object to iterate over.
      #
      # Returns nothing.
      def detail_list(name)
        list = List.find(name)
        list.items.sort {|x,y| x.name <=> y.name }.each do |item|
          output "    #{item.short_name}:#{item.spacer} #{item.value}"
        end
      end

      # Public: Add a new List.
      #
      # name - The String name of the List.
      #
      # Example
      #
      #   Commands.create_list("snippets")
      #
      # Returns the newly created List.
      def create_list(name)
        lists = (storage.lists << List.new(name))
        storage.lists = lists
        output "Boom! Created a new list called \"#{name}\"."
        save!
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
        output "You sure you want to delete everything in \"#{name}\"? (y/n):"
        if $stdin.gets.chomp == 'y'
          List.delete(name)
          output "Boom! Deleted all your #{name}."
          save!
        else
          output "Just kidding then."
        end
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
        list = List.find(list)
        list.add_item(Item.new(name, value))
        output "Boom! \"#{name}\" in \"#{list.name}\" is \"#{value}\". Got it."
        save!
      end

      # Public: Remove a named Item.
      #
      # list_name - The String name of the List.
      # name      - The String name of the Item.
      #
      # Example
      #
      #   Commands.delete_item("a-list-name", "an-item-name")
      #
      # Returns nothing.
      def delete_item(list_name, name)
        list = List.find(list_name)
        list.delete_item(name)
        output "Boom! \"#{name}\" is gone forever."
        save!
      end

      # Public: Search for an Item in all lists by name. Drops the
      # corresponding entry into your clipboard.
      #
      # name - The String term to search for in all Item names.
      #
      # Returns the matching Item.
      def search_items(name)
        item = storage.items.detect do |item|
          item.name == name
        end

        output Clipboard.copy(item)
      end

      # Public: Search for an Item in a particular list by name. Drops the
      # corresponding entry into your clipboard if found.
      #
      # list_name - The String name of the List in which to scope the search.
      # item_name - The String term to search for in all Item names.
      #
      # Returns the matching Item if found.
      def search_list_for_item(list_name, item_name)
        list = List.find(list_name)
        item = list.find_item(item_name)

        if item
          output Clipboard.copy(item)
        else
          output "\"#{item_name}\" not found in \"#{list_name}\""
        end
      end

      # Public: Save in-memory data to disk
      #
      # Returns whether or not data was saved.
      def save!
        storage.save!
      end

      # Public: Launches JSON file in an editor for you to edit manually. Uses
      # the $EDITOR environment variable for editing.
      #
      # Returns nothing.
      def edit
        system "`echo $EDITOR` #{storage.json_file} &"
        output "Boom! Make your edits, and do be sure to save."
      end

      # Public: Prints all the commands of boom.
      #
      # Returns nothing.
      def help
        text = %{
          - boom: help ---------------------------------------------------

          boom                          display high-level overview
          boom all                      show all items in all lists
          boom edit                     edit the boom JSON file in $EDITOR
          boom help                     this help text

          boom <list>                   create a new list
          boom <list>                   show items for a list
          boom <list> delete            deletes a list

          boom <list> <name> <value>    create a new list item
          boom <name>                   copy item's value to clipboard
          boom <list> <name>            copy item's value to clipboard
          boom <list> <name> delete     deletes an item

          all other documentation is located at:
            https://github.com/holman/boom
        }.gsub(/^ {8}/, '') # strip the first eight spaces of every line

        output text
      end
    end
  end
end
