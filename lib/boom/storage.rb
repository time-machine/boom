module Boom
  class Storage
    JSON_FILE = "#{ENV['HOME']}/.boom"

    # Public: initializes a Storage instance by loading in your persisted data.
    #
    # Returns the Storage instance.
    def initialize
    end

    # Public: the list of Lists in your JSON data.
    #
    # Returns an Array of List objects.
    attr_writer :lists

    # Public: persists your in-memory objects to disk in JSON format.
    #
    # Returns true if successful, false if unsuccessfull.
    def save
      to_json
    end

    # Public: the JSON representation of the current List and Item assortment
    # attached to the Storage instance.
    #
    # Returns a String JSON representation of its Lists and their Items.
    def to_json
      lists.collect(&:to_json)
    end

    # INTERNAL METHODS

    # Take a JSON representation of data and explode it out into the consituent
    # Lists and Items for the given Storage instance.
    #
    # Returns nothing.
    def explode_json(json)
    end
  end
end
