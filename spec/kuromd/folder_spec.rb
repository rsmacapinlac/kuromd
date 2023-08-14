# frozen_string_literal: true

require 'kuromd/folder'

RSpec.describe 'Kuromd::Folder' do
  context 'initialize' do
    it 'should raise an error if config is not passed' do
      expect { Kuromd::Folder.new }.to raise_error 'Configuration not found'
    end
    it 'should raise an error if config [\'journal\'] is missing' do
      @config = Kuromd::Config.new({ config_file: 'spec/fixtures/configuration_folder_missing_journal.yml' })
      expect { Kuromd::Folder.new({ config: @config }) }.to raise_error 'Journal params not found'
    end
    it 'should raise an error if config [\'journal\'][\'inbox\'] is missing' do
      @config = Kuromd::Config.new({ config_file: 'spec/fixtures/configuration_folder_missing_journal_inbox.yml' })
      expect { Kuromd::Folder.new({ config: @config }) }.to raise_error 'Inbox params not found'
    end

    context 'notes' do
      before :each do
        @config = Kuromd::Config.new({ config_file: 'spec/fixtures/configuration.yml' })
        @folder = Kuromd::Folder.new({ config: @config })
      end
    end
  end
end
