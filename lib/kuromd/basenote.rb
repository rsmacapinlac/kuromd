# frozen_string_literal: true

module Kuromd
  # Super class for all Notes
  class BaseNote
    def initialize(params = {})
      raise 'Params required' if params.nil?

      @note_data = params[:note_data]

      # ensure path is absolute
      @note_path = @note_data[:full_path]
      @note_path = File.expand_path(@note_path)
    end

    def valid?; end
    def process; end

    def self.autoload_notes
      require 'kuromd/one_on_one/note'
      require 'kuromd/journal/note'
    end

    def self.categorize(params = {})
      autoload_notes

      objs = []
      note_data = params[:note_data]
      note_type = cleanup_note_types(note_data)

      # puts note_type.include?("Journal")
      objs.push(Kuromd::OneOnOne::Note.new({ note_data: })) if note_type.include?('One on one')
      objs.push(Kuromd::Journal::Note.new({ note_data: })) if note_type.include?('Journal')
      objs
    end

    private_class_method def self.cleanup_note_types(note_data)
      note_type = note_data['note_type']
      unless note_data['note_type'].is_a?(Array)
        note_type = []
        note_type.push(note_data['note_type'])
        note_data['note_type'] = note_type
        note_type = note_data['note_type']
      end
      note_type
    end
  end
end

