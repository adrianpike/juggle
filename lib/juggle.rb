require 'logger'
require 'juggle/version'
require 'tempfile'
require 'json'
require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

class Juggle
  
  class ArgumentError < Exception; end
  
  autoload :Jugfile, 'juggle/jugfile'
  autoload :Project, 'juggle/project'
  autoload :Resource, 'juggle/resource'
  autoload :Application, 'juggle/application'

  Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'juggle', 'resource', '*')].each {|p| 
    require p # kinda screws up autoload, but i don't know how to autoload a whole dir without digging
  }
  
  
  def self.log(entry, level = Logger::INFO)
    @logger ||= Logger.new($stdout)
    @logger.level = Logger::ERROR
    @logger.log(level, entry)
  end
  
end