# frozen_string_literal: true

module Kuromd
  # Super class for all Notes
  class BaseNote
    attr_accessor :note_data
    NOTE_TYPE = nil

    def initialize(params = {})
      raise 'Params required' if params.nil?

      @note_data = params[:note_data]

      # ensure path is absolute
      @note_path = @note_data[:full_path]
      @note_path = File.expand_path(@note_path)
    end

    def note_type; end
    def self.note_type; end
    def valid?; end
    def process; end

    def self.assign_note_objs(params = {})
      autoload_notes

      objs = []
      note_data = params[:note_data]
      note_type = cleanup_note_types(note_data)

      self.descendants.each do |descendant|
        obj = descendant.new({ note_data: })
        objs.push(obj) if obj.valid?
      end

      # puts note_type.include?("Journal")
      # obj = Kuromd::OneOnOne::Note.new({ note_data: }) if note_type.include?('One on one')
      # objs.push(obj) if obj.valid?
      # obj = Kuromd::Journal::Note.new({ note_data: }) if note_type.include?('Journal')
      # objs.push(obj) if obj.valid?

      objs
    end

    def self.categorize_by_note_objs(params = {})
      autoload_notes

      note_data = params[:note_data]
      note_objs = params[:note_objs]

      note_types = []

      note_objs.each do |note_obj|
        note_types.push(note_obj.note_type)
      end

      note_types

    end

    private_class_method def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    private_class_method def self.autoload_notes
      require 'kuromd/one_on_one/note'
      require 'kuromd/journal/note'
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

    private

    def category?
      @note_data['note_type'].include?(note_type)
    end
  end
end
