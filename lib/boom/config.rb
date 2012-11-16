# coding: utf-8

# Config manages all the config information for boom and its backends. It's a
# simple JSON Hash that gets persisted to `~/.boom` on-disk. You may access it
# as a Hash:
#
#     config.attributes = { :backend => "JSON" }
#     config.attributes[:backend]
#     # => "json"
#
#     config.attributes[:backend] = "Redis"
#     config.attributes[:backend]
#     # => "redis"
module Boom
  class Config
    # the main config file for boom
    FILE = "#{ENV['HOME']}/.boom.conf"

    # Public: The attributes Hash for configuration options. The attributes
    # needed are dictacted by each backend, but the `backend` option must be
    # present.
    attr_reader :attributes

    # Public: Creates a new instance of Config.
    #
    # This will load the attributes from boom's config file, or bootstrap it
    # if this is a new install. Bootstrapping defaults to the JSON backend.
    #
    # Returns nothing.
    def initialize
      bootstrap unless File.exist?(file)
      load_attributes
    end

    # Public: Accessor for the configuration file.
    #
    # Returns the String file path.
    def file
      FILE
    end

    # Public: Saves an empty, barebones hash to @attributes for the purpose of
    # new user setup.
    #
    # Returns whether the attributes were saved.
    def bootstrap
      @attributes = {
        :backend => 'JSON'
      }
      save
    end

    # Public: Assigns a Hash to the configuration attributes object. The
    # contents of the attributes Hash depends on what the backend needs. A
    # `backend` key MUST be present, however.
    #
    # attrs - The Hash representation of attributes to persist to disk.
    #
    # Examples
    #
    #   config.attributes = {"backend" => "json"}
    #
    # Returns whether the attributes were saved.
    def attributes=(attrs)
      @attributes = attrs
      save
    end

    # Public: Loads and parses the JSON tree from disk into memory and stores
    # it in the attributes Hash.
    #
    # Returns nothing.
    def load_attributes
      @attributes = Yajl::Parser.new.parse(File.new(file, 'r'))
    end

    # Public: Writes the in-memory JSON Hash to disk.
    #
    # Returns nothing.
    def save
      json = Yajl::Encoder.encode(attributes, :pretty => true)
      File.open(file, 'w') { |f| f.write(json) }
    end
  end
end