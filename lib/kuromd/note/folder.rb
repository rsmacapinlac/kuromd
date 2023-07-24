# frozen_string_literal: true

require 'kuromd/configurable'
require 'kuromd/note/one_on_one'
require 'ruby_matter'
require 'terminal-table'

module Kuromd
  module Note
    # Represents a folder of notes, this object should categorize each note and have the ability to process.
    class Folder
      include Configurable

      attr_accessor :config, :notes_folder, :notes

      def initialize
        @config = Kuromd::Configurable.get_config
        params = @config.params

        @notes_folder = params['folder']
        @notes_folder = File.expand_path(@notes_folder)

        raise 'Folder not found' unless Dir.exist?(@notes_folder)

        # TODO: test for creating the hash
        @notes = []
        read_files
      end

      def build_table
        # convert @notes into something that can be used
        rows = []
        count = 1
        @notes.each do |note|
          rows << [count, note[:filename], note[:note_type], note[:note_obj], note[:valid]]
          count += 1
        end

        Terminal::Table.new do
          self.headings = ['index', 'Filename', 'Note type', 'Note Obj', 'valid?']
          self.rows = rows
        end
      end

      def process
        @notes.each do |note|
          note[:note_obj].process
        end
      end

      private

      def read_files
        Dir.chdir @notes_folder
        Dir.glob('*.md') do |filename|
          full_path = File.join(@notes_folder, filename)
          note_data = parse_markdown(file_full_path: full_path)
          note_type = note_data['note_type']
          note_data[:full_path] = full_path
          note_obj  = Kuromd::Note::Note.categorize({ note_data: })
          valid     = note_obj.valid?
          @notes.push({ filename:, full_path:, note_type:, note_obj:, valid: })
        end
      end

      def parse_markdown(file_full_path:)
        parser = RubyMatter.parse(File.read(file_full_path))

        note_data = parser.data
        note_data['content'] = parser.content

        note_data
        # @note_data = parser.data
        # @note_data['content'] = parser.content
        # @note_data['note_type']
      end
    end
  end
end
