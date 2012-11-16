# Storage is the middleman between changes the client makes in-memory and how
# it's actually persisted to disk (and vice-versa). There are also a few
# convenience methods to run searches and operations on the in-memory hash.
module Boom
  module Storage
    class Base
      # Public: Initializes a Storage instance by loading in your persisted data
      # from adapter.
      #
      # Returns the Storage instance.
      def initialize
        @lists = Boom.adapter.lists
      end

      # Public: The in-memory collection of all Lists attached to this Storage
      # instance.
      #
      # lists - An array of individual List items.
      #
      # Returns nothing.
      attr_writer :lists

      # Public: The list of Lists in your JSON data, sorted by number of items
      # descending.
      #
      # Returns an Array of List objects.
      def lists
        @lists.sort_by { |list| -list.items.size }
      end

      # Public: Saving in-memory data to any adapter.
      #
      # Returns true or false.
      def save!
        Boom.adapter.save(to_json)
      end

      # Public: Tests whether a named List exists.
      #
      # name - The String name of a List.
      #
      # Returns true if found, false if not.
      def list_exists?(name)
        @lists.detect { |list| list.name == name }
      end

      # Public: All Items in storage.
      #
      # Returns an Array of all Items.
      def items
        @lists.collect(&:items).flatten
      end

      # Public: Tests whether a named Item exists.
      #
      # name - The String name of an Item.
      #
      # Returns true if found, false if not.
      def item_exists?(name)
        items.detect { |item| item.name == name }
      end

      # Public: The JSON representation of the current List and Item assortment
      # attached to the Storage instance.
      #
      # Returns a String JSON representation of its Lists and their Items.
      def to_json
        Yajl::Encoder.encode(to_hash, :pretty => true)
      end

      # Public: Creates a Hash of the representation of the in-memory data
      # structure. This percolates down to Items by calling to_hash on the List,
      # which in tern calls to_hash on individual Items.
      #
      # Returns a Hash of the entire data set.
      def to_hash
        { :lists => lists.collect(&:to_hash) }
      end
    end
  end
end
