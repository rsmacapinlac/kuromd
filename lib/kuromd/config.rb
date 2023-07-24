# frozen_string_literal: true

require 'yaml'

module Kuromd
  # Handles pulling the configuration from a configuration file.
  class Config
    attr_accessor :params

    def configuration_folder
      '~/.config/kuromd'
    end

    def configuration_file
      'configuration.yml'
    end

    def initialize(params = {})
      key = params[:key]
      config_file = File.expand_path(File.join(configuration_folder, configuration_file))
      # replace the configuration with what was passed
      config_file = File.expand_path params[:config_file] unless params[:config_file].nil?
      @params = YAML.load(File.read(config_file))
      # narrow down the parameters if a key is present
      @params = @params[key] unless key.nil?
    end
  end
end
