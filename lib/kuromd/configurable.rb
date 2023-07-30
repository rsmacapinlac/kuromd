# frozen_string_literal: true

require 'kuromd/config'

module Kuromd
  module Configurable

    @config = nil

    def set_config(value)
      @config = value
    end

    def get_config
      @config
    end

    def configure(params = {})
      if @config.nil?
        set_config(Kuromd::Config.new({ config_file: params[:config_file], key: params[:key] }))
      else
        get_config
      end
    end
  end
end
