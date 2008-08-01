$:.unshift File.dirname(__FILE__)
require 'rubygems'
require 'yaml'
require 'fileutils'
require 'digest/sha1'
require File.dirname(__FILE__) + '/../vendor/grit/lib/grit'
# Grit.debug = true
require 'hive/schema.rb'
require 'hive/cell.rb'
require 'hive/base.rb'
Hive::Base.send(:include, Hive::Schema)
module Hive
  VERSION = '1'
end