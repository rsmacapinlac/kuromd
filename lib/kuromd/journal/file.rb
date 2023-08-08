# frozen_string_literal: true

require 'kuromd/basefile'
require 'kuromd/journal/fileable'

module Kuromd
  module Journal
    # Represents a file for a Journal
    # process method will organize the note into it's
    # base folder
    class File < Kuromd::BaseFile
      include Fileable

      attr_accessor :file_path

      def initialize(params = {})
        super
      end

      # def valid?
      # end

      # def process
      # end
    end
  end
end
