# frozen_string_literal: true

module Kuromd
  # Super class for all files
  class BaseFile
    attr_accessor :note_type

    def initialize(params = {}); end

    def valid?; end
    def process; end

    # Only one type at the moment, comfortable with hard coding
    def self.assign_file_objs(params = {})
      autoload_files
      objs = []
      objs.push(Kuromd::Journal::File.new(params))
    end

    # Only one type at the moment, comfortable with hard coding
    def self.cleanup_types
      note_type = []
      note_type.push('Journal file')
      note_type
    end

    private_class_method def self.autoload_files
      require 'kuromd/journal/file'
    end
  end
end
