# frozen_string_literal: true

module Kuromd
  # Super class for all Notes
  class BaseNote
    attr_accessor :config, :note_data, :note_type

    def initialize(params = {})
      raise 'Params required' if params.nil?

      @config = params[:config]
      @note_data = params[:note_data]
      # ensure path is absolute
      @note_path = @note_data['full_path']
      @note_path = File.expand_path(@note_path)
    end

    def valid?; end
    def process; end

    def self.parse_markdown(filepath:)
      parser = RubyMatter.parse(File.read(filepath))
      note_data = parser.data
      note_data['content'] = parser.content
      note_data['full_path'] = filepath
      note_data
    end

    def self.assign_note_objs(params = {})
      autoload_notes

      objs = []
      note_data = params[:note_data]
      config = params[:config]

      # if the note type is not an array, make it one
      # note_type = cleanup_note_types(note_data)
      # puts note_type

      descendants.each do |descendant|
        obj = descendant.new({ note_data:, config: })
        objs.push(obj) if obj.valid?
      end

      objs
    end

    def self.categorize_by_note_objs(params = {})
      autoload_notes

      note_data = params[:note_data]
      note_objs = params[:note_objs]

      note_types = []

      note_objs.each do |note_obj|
        # puts note_obj.valid?
        note_types.push(note_obj.note_type) if note_obj.valid?
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
      Kuromd.logger.debug "@note_data['note_type']: #{@note_data['note_type']}, @note_type: #{@note_type} "
      @note_data['note_type'].include?(@note_type)
    end
  end
end
