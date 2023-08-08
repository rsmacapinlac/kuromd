# frozen_string_literal: true

require 'date'
require 'dates_from_string'
require 'fileutils'

module Kuromd
  module Journal
    # defines the functions for managing files and folders for journals
    module Fileable
      def create_journal_folder(base_path:, date:)
        date = Date.parse(date.to_s)
        full_date_path = build_date_path(base_path:, date:)
        Kuromd.logger.info "Creating folder #{full_date_path}" if FileUtils.mkdir_p full_date_path
        full_date_path
      end

      def fileable?
        fileable = true
        fileable = false if @file_date.nil?
        fileable
      end

      def find_date_from_filename
        DatesFromString.new.find_date(@file_path)[0]
      end

      def move(dest_folder:, filename:)
        fullpath = ::File.expand_path(filename)
        dest_folder = ::File.expand_path(dest_folder)

        file_to_move = ::File.basename(fullpath)
        extname = ::File.extname(fullpath)

        if file_to_move.index(file_date).zero?
          # date was found in the beginning of the string, assume it follows
          # format: date - filename.ext
          file_to_move.delete_prefix!("#{file_date} - ")
        else
          # date was note found in the beginning of the string, assume it follows
          # format: filename - date.ext
          file_to_move.delete_suffix!(" - #{file_date}#{extname}")
          file_to_move = "#{file_to_move}#{extname}"
        end
        dest = ::File.join(dest_folder, file_to_move)
        Kuromd.logger.info "Move: #{fullpath} to #{dest}" if FileUtils.mv fullpath, dest
        # Kuromd.logger.info "Move: #{fullpath} to #{dest}"
      end

      private

      def build_date_path(base_path:, date:)
        working_date  = date

        padded_year   = working_date.year.to_s
        padded_month  = working_date.month.to_s.rjust(2, '0')
        padded_day    = working_date.mday.to_s.rjust(2, '0')

        day_folder    = "#{padded_day} #{Date::ABBR_DAYNAMES[working_date.wday]}"
        folder_path   = ::File.join(base_path, padded_year, padded_month, day_folder)

        ::File.expand_path(folder_path)
      end
    end
  end
end
