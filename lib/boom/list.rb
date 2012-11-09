module Boom
  class List
    # Public: Creates a new List instance in-memory.
    #
    # name - The name of the List. Fails if already used.
    #
    # Returns the unpersisted List instance.
    def initialize(name)
      @items = []
      @name = name
    end

    # Public: Lets you access the array of items contained within this List.
    #
    # Returns an Array of Items.
    attr_accessor :items

    # Public: The name of the List.
    #
    # Returns the String name.
    attr_accessor :name

    # Public: Associates an Item with this List.
    #
    # item - The Item object to associate with this List.
    #
    # Returns the current set of items.
    def add_item(item)
      @items << item
    end

    # Public: A Hash representation of this List.
    #
    # Returns a Hash of its own data and its child Items.
    def to_hash
      { name => items.collect(&:to_hash) }
    end
  end
end
