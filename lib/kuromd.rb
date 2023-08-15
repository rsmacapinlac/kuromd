# frozen_string_literal: true

require 'dotenv'
require 'fileutils'
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
      env = ENV['ENVIRONMENT']
      @logger = init_logger(env)
      # @logger = Logger.new($stdout) unless ENV['ENVIRONMENT'] == 'development'
      # @logger.level = Logger::WARN
      @logger.info 'Logger initialized'
    end
    @logger
  end

  def self.init_logger(env)
    # create the logs folder if not there
    FileUtils.mkdir_p 'logs'

    # assume production
    logfile = "logs/#{env}.log"
    logger = Logger.new(logfile)
    if env == 'development'
      logger = Logger.new($stdout)
      logger.level = Logger::DEBUG
    end
    logger
  end
end
