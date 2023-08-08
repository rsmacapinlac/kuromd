# frozen_string_literal: true

require 'kuromd/basefile'
require 'kuromd/configurable'
require 'kuromd/journal/fileable'

module Kuromd
  module Journal
    # Represents a file for a Journal
    # process method will organize the note into it's
    # base folder
    class File < Kuromd::BaseFile
      include Fileable
      include Configurable

      attr_accessor :base_folder, :file_path, :file_date

      def initialize(params = {})
        super

        @config = Kuromd::Configurable.get_config
        @base_folder = @config.params['journal']['base_folder']

        @file_path = params[:full_path]
        @file_date = find_date_from_filename
        Kuromd.logger.info "Initialized Journal File #{@file_path}"
      end

      # def valid?
      # end

      def process
        return unless fileable?

        journal_folder = create_journal_folder(base_path: @base_folder, date: @file_date)
        move(dest_folder: journal_folder, filename: @file_path)
      end
    end
  end
end
