module Boom
  class Item
    # Public: creates a new Item object that's associated to a particular List.
    #
    # name  - The String name of the Item
    # value - The String value of the Item
    # list  - The List object that the Item belongs to
    #
    # Examples
    #
    #   Item.new("github", "http://github.com", github_list)
    #
    # Returns the newly initialized Item.
    def initialize(name, value, list)
    end

    # Public : deletes the Item object.
    #
    # Returns true deletion if successful, false if unsuccessfull.
    def delete
    end

    # Public: creates a JSON data structure for this Item.
    #
    # Returns a String of its data in JSON format
    def to_json
    end
  end
end
