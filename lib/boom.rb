# coding: utf-8

begin
  require 'rubygems'
rescue LoadError
end

require 'fileutils'
require 'yajl'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'boom/clipboard'
require 'boom/command'
require 'boom/config'
require 'boom/item'
require 'boom/list'
require 'boom/storage'
require 'boom/storage/base'
require 'boom/storage/json'
require 'boom/storage/mongodb'

module Boom
  VERSION = '0.0.8'

  extend self

  def storage
    @storage ||= Boom::Storage.backend
  end

  def config
    @config ||= Boom::Config.new
  end
end

unless Symbol.method_defined?(:to_proc)
  class Symbol
    def to_proc
      Proc.new { |obj, *args| obj.send(self, *args) }
    end
  end
end
