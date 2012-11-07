module Boom
  class Storage
    JSON_FILE = "#{ENV['HOME']}/.boom"

    # Public: Initializes a Storage instance by loading in your persisted data.
    #
    # Returns the Storage instance.
    def initialize
      @lists = []
      explode_json(JSON_FILE)
    end

    attr_writer :lists

    # Public: The list of Lists in your JSON data, sorted by number of items
    # descending.
    #
    # Returns an Array of List objects.
    def lists
      @lists.sort_by { |list| -list.items.size }
    end

    # Public: All Items in storage.
    #
    # Returns an Array of all Items.
    def items
      @lists.collect(&:items).flatten
    end

    # Public: Persists your in-memory objects to disk in JSON format.
    #
    # Returns true if successful, false if unsuccessfull.
    def save!
      File.open(JSON_FILE, 'w') { |f| f.write(to_json) }
    end

    # Public: The JSON representation of the current List and Item assortment
    # attached to the Storage instance.
    #
    # Returns a String JSON representation of its Lists and their Items.
    def to_json
      Yajl::Encoder.encode(to_hash)
    end

    def to_hash
      { :lists => lists.collect(&:to_hash) }
    end

    # INTERNAL METHODS

    # Take a JSON representation of data and explode it out into the consituent
    # Lists and Items for the given Storage instance.
    #
    # Returns nothing.
    def explode_json(json)
      FileUtils.touch(json)
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
  end
end
