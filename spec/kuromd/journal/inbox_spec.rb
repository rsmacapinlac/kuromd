# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'
require 'kuromd/journal/inbox'
require 'kuromd/journal/folder'

RSpec.describe 'Kuromd::Journal::Inbox' do
  before(:all) do
    @test_base_path = File.join(Dir.tmpdir, 'JournalFolderTest').to_s
    FileUtils.rm_r @test_base_path, force: true
    FileUtils.mkdir_p @test_base_path
  end
  after(:all) do
    FileUtils.rm_r @test_base_path, force: true
  end

  context 'initialize' do
    it 'should require inbox_path' do
      expect { Kuromd::Journal::Inbox.new }.to raise_error(ArgumentError, 'missing keyword: :inbox_path')
    end
  end

  context 'on create' do
    before (:all) do
    end
  end
end
