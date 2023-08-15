# frozen_string_literal: true

require 'dotenv'
require 'yaml'
require 'kuromd'

module Kuromd
  # Handles pulling the configuration from a configuration file.
  class Config
    attr_accessor :params, :config_filepath

    def configuration_folder
      '~/.config/kuromd'
    end

    def configuration_file
      'configuration.yml'
    end

    def get_config(key)
      if key.nil?
        @params
      else
        @params[key]
      end
    end

    def initialize(params = {})
      Dotenv.load

      @config_filepath = File.join(configuration_folder, configuration_file)
      @config_filepath = params[:config_file] unless params[:config_file].nil?
      config_file = File.expand_path(@config_filepath)
      # Kuromd.logger.info "Configuration file: #{config_file}"

      # replace the configuration with what was passed
      @params = {}
      @params = YAML.load(File.read(config_file)) if File.exist?(config_file)

      # assume production unless otherwise specified
      @params['environment'] = 'production'
      unless ENV['ENVIRONMENT'].nil?
        @params['environment'] = ENV['ENVIRONMENT']
      end

      Kuromd.logger.info "Configuration initialized: #{config_file}" unless @params.nil?
    end
  end
end
