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

      def find_date_from_filename(filepath)
        DatesFromString.new.find_date(filepath)[0]
      end

      def move(params = {})
        dest_folder = params[:dest_folder]
        source_file = ::File.expand_path(params[:source_path])

        dest_filename = ::File.basename(source_file)
        dest_filename = params[:rename_to] unless params[:rename_to].nil?

        destination = ::File.join(dest_folder, dest_filename)
        Kuromd.logger.info "Move: #{source_file} to #{destination}" if FileUtils.mv source_file, destination
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
