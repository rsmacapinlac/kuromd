# frozen_string_literal: true

require 'kuromd/config'

RSpec.describe Kuromd::Config do
  describe 'initialization' do
    it 'has defaults' do
      config = Kuromd::Config.new
      expect(config.config_filepath).to eq '~/.config/kuromd/configuration.yml'
    end
    it 'can accept a config file' do
      config = Kuromd::Config.new({
        config_file: 'spec/fixtures/configuration.yml'
      })
      expect(config.config_filepath).to eq 'spec/fixtures/configuration.yml'
    end
    it 'should return parameters' do
      fixtures_config_file = 'spec/fixtures/configuration.yml'
      params = YAML.load(File.read(File.expand_path(fixtures_config_file)))
      config = Kuromd::Config.new({
        config_file: fixtures_config_file
      })
      expect(config.params).to eq params
    end
  end
end
