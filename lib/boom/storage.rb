# Storage is the middleman between changes the client makes in-memory and how
# it's actually persisted to disk (and vice-versa). There are also a few
# convenience methods to run searches and operations on the in-memory hash.
module Boom
  class Storage
    JSON_FILE = "#{ENV['HOME']}/.boom"

    # Public: The path to the JSON file used by boom.
    #
    # Returns the String path of boom's JSON representation.
    def json_file
      JSON_FILE
    end

    # Public: Initializes a Storage instance by loading in your persisted data.
    #
    # Returns the Storage instance.
    def initialize
      @lists = []
      explode_json(json_file)
    end

    # Public: The in-memory collection of all Lists attached to this Storage
    # instance.
    #
    # list - An Array of individual List items.
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

    # Public: Tests whether a named List exist.
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

    # Public: tests whether a named Item exist.
    #
    # name - The String name of an Item.
    #
    # Returns true if found, false if not.
    def item_exists?(name)
      items.detect { |item| item.name == name }
    end

    # Public: Persists your in-memory objects to disk in JSON format.
    #
    # Returns true if successful, false if unsuccessfull.
    def save!
      File.open(json_file, 'w') { |f| f.write(to_json) }
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

    # INTERNAL METHODS

    # Take a JSON representation of data and explode it out into the consituent
    # Lists and Items for the given Storage instance.
    #
    # Returns nothing.
    def explode_json(json)
      bootstrap_json unless File.exist?(json)

      storage = Yajl::Parser.new.parse(File.new(json, 'r'))

      storage['lists'].each do |lists|
        lists.each do |list_name, items|
          @lists << list = List.new(list_name)

          items.each do |item|
            item.each do |name, value|
              list.add_item(Item.new(name, value))
            end
          end
        end
      end
    end

    # Takes care of bootstrapping the JSON file, both in terms of creating the
    # file and in terms of creating a skeleton JSON schema.
    #
    # Returns true if successfully saved.
    def bootstrap_json
      FileUtils.touch json_file
      save!
    end
  end
end
