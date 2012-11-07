module Boom
  class Item
    attr_accessor :name
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

    # Public : Deletes the Item object.
    #
    # Returns true deletion if successful, false if unsuccessfull.
    def delete
    end

    # Public: Creates a Hash for this Item.
    #
    # Returns a Hash of its data.
    def to_hash
      { @name => @value }
    end
  end
end
