# frozen_string_literal: true

require_relative 'kuromd/version'
require 'logger'

# top level module to create abstraction and avoid any conflicts
module Kuromd
  class Error < StandardError; end
  # Your code goes here...

  @logger = nil

  # TODO: create the ability to configure logger
  def self.logger
    if @logger.nil?
      @logger = Logger.new($stdout)
      # @logger.level = Logger::WARN
      @logger.info 'Logger initialized'
    end
    @logger
  end
end
