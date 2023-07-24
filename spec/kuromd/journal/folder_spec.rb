# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'
require 'kuromd/journal/inbox'
require 'kuromd/journal/folder'

RSpec.describe 'Kuromd::Journal::Folder' do
  before (:all) do
    @test_base_path = File.join(Dir.tmpdir, 'JournalFolderTest').to_s
    FileUtils.rm_r @test_base_path, force: true
    FileUtils.mkdir_p @test_base_path
  end
  after (:all) do
    FileUtils.rm_r @test_base_path, force: true
  end

  context 'initialize' do
    it 'should require params' do
      expect { Kuromd::Journal::Folder.new }.to raise_error(KeyError, 'key not found: :base_path')
    end

    it 'should default to today\'s date' do
      expect(Kuromd::Journal::Folder.new({ base_path: @test_base_path }).journal_date).to eq(Date.today)
    end

    it 'should build the folder path correctly' do
      test_date = '2021/12/01'
      jf = Kuromd::Journal::Folder.new({ journal_date: test_date, base_path: @test_base_path })
      expect(jf.full_day_path).to eq(File.join(@test_base_path, '2021/12/01 Wed'))
    end
    context 'folders' do
      before (:all) do
        @jp = Kuromd::Journal::Folder.new(base_path: @test_base_path)
      end
      it 'should default not created' do
        expect(@jp.created).to eq(false)
      end
      it 'should not create the physical folder' do
        expect(File.exist?(@jp.full_day_path)).to eq(false)
      end
    end
  end

  context 'on create' do
    before (:all) do
      @jp = Kuromd::Journal::Folder.new(base_path: @test_base_path)
    end
    it 'should mkdir the folder' do
      @jp.create
      expect(File.exist?(@jp.full_day_path)).to eq(true)
    end
    after (:all) do
      FileUtils.rmdir @jp.full_day_path
    end
  end
end
