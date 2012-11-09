module Boom
  class Item
    # Public: The String name of the Item.
    attr_accessor :name

    # Public: The String value of the Item.
    attr_accessor :value

    # Public: Creates a new Item object.
    #
    # name  - The String name of the Item.
    # value - The String value of the Item.
    #
    # Examples
    #
    #   Item.new("github", "http://github.com")
    #
    # Returns the newly initialized Item.
    def initialize(name, value)
      @name = name
      @value = value
    end

    # Public: Creates a Hash for this Item.
    #
    # Returns a Hash of its data.
    def to_hash
      { @name => @value }
    end
  end
end
