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
      include Configurable
      include Fileable

      NOTE_TYPE = 'Journal file'

      attr_accessor :base_folder, :file_path, :file_date

      def initialize(params = {})
        super

        @config = params[:config]
        @base_folder = @config.params['journal']['base_folder']

        @file_path = params[:full_path]
        @file_date = find_date_from_filename(@file_path)
        Kuromd.logger.info "Initialized Journal File #{@file_path}, #{@file_date}"
      end

      def cleanup_filename
        filename = ::File.basename(@file_path)
        date_position = filename.index(@file_date)

        if date_position.zero?
          filename.delete_prefix!("#{@file_date} - ")
        else
          extname = ::File.extname(filename)
          filename.delete_suffix!(" - #{@file_date}#{extname}")
          filename += extname
        end

        filename
      end

      def valid?
        # assume valid unless date doesn't exist
        is_valid = true
        is_valid = false if @file_date.nil?
        Kuromd.logger.info "Journal File object valid? #{is_valid}"

        is_valid
      end

      def process
        return unless valid?

        journal_folder = create_journal_folder(base_path: @base_folder, date: @file_date)
        move({ dest_folder: journal_folder,
               source_path: @file_path,
               rename_to: cleanup_filename })
      end
    end
  end
end
