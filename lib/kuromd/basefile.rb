# frozen_string_literal: true

module Kuromd
  # Super class for all Notes
  class BaseFile
    def initialize(params = {})
    end

    def valid?; end
    def process; end

    def self.assign_file_objs(params = {})
      autoload_files
      objs = []
      objs.push(Kuromd::Journal::File.new(params))
    end

    def self.cleanup_types
      note_type = []
      note_type.push('Journal File')
      note_type
    end

    private_class_method def self.autoload_files
      require 'kuromd/journal/file'
    end
  end
end
