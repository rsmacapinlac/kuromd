# frozen_string_literal: true

require 'kuromd/basefile'
require 'kuromd/basenote'
require 'ruby_matter'
require 'terminal-table'

module Kuromd
  # Represents a folder of stuff, this object should categorize each item
  # and have the ability to process.
  class Folder
    attr_accessor :config, :folder_path, :notes

    def initialize(params = {})
      raise StandardError, 'Configuration not found' if params[:config].nil?
      @config = params[:config]

      raise StandardError, 'Journal params not found' if @config.params['journal'].nil?
      raise StandardError, 'Inbox params not found' if @config.params['journal']['inbox'].nil?

      @folder_path = @config.params['journal']['inbox']
      @folder_path = File.expand_path(@folder_path)
      raise 'Folder not found' unless Dir.exist?(@folder_path)

      # TODO: test for creating the hash
      @notes = []
      process_files
    end

    def build_table
      # convert @notes into something that can be used
      rows = []
      count = 1
      @notes.each do |note|
        rows << [count, note[:filename], note[:note_type]]
        count += 1
      end

      Terminal::Table.new do
        self.headings = ['index', 'Filename', 'Note type']
        self.rows = rows
      end
    end

    def process
      @notes.each do |note|
        note_objects = note[:note_objs]
        note_objects.each do |note_object|
          note_object.process
        end
      end
    end

    private

    # TODO: refactor this (rubocop doesn't like it)
    def process_files
      Dir.chdir @folder_path
      Dir.glob('*') do |filename|
        full_path = File.join(@folder_path, filename)
        extension = File.extname(full_path)

        # ignore any folders in the identified folder
        unless File.directory?(full_path)
          if extension == '.md'
            # puts filename
            note_data = Kuromd::BaseNote.parse_markdown(filepath: full_path)
            note_objs = Kuromd::BaseNote.assign_note_objs({ note_data:, config: @config })
            note_type = Kuromd::BaseNote.categorize_by_note_objs({ note_data:, note_objs: })
          else
            note_objs = Kuromd::BaseFile.assign_file_objs({full_path:, config: @config })
            note_type = Kuromd::BaseFile.cleanup_types
          end
          @notes.push({ filename:, full_path:, note_type:, note_objs: })
        end
      end
    end
  end
end
