# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'dates_from_string'

module Kuromd
  module Journal
    # Given a date and a base path, this object will create a place to file
    # a journal item
    class Folder
      attr_accessor :created, :journal_date, :base_path
      attr_reader   :full_day_path

      def initialize(params = {})
        raise 'Params required' if params.nil? == true

        # @base_path is required will throw KeyError if not found
        @base_path    = params.fetch(:base_path)
        @journal_date = params.fetch(:journal_date, Date.today)

        @full_day_path = build_date_path(Date.parse(@journal_date.to_s))
        @created = Dir.exist?(@full_day_path)
      end

      def create
        FileUtils.mkdir_p @full_day_path if @created == false
        @created = true
      end

      def save(filename:, noop: false)
        _filename = File.expand_path(filename)
        create if @created == false

        _noop = noop

        file_date = DatesFromString.new.find_date(filename)
        date_found = !file_date.empty?
        new_filename = File.basename(_filename)
        if new_filename.index(file_date[0]) == 0 and date_found == true
          # date was found in the beginning of the string, assume it follows
          # format: date - filename.ext
          new_filename = new_filename.delete_prefix("#{file_date[0]} - ")
        end
        dest = File.join(@full_day_path, new_filename)
        # puts "move: #{_filename} to #{dest}"
        FileUtils.mv _filename, dest, noop: _noop
      end

      def self.organize(filename:, base_path:, dry_run: false)
        _fullpath = File.expand_path(filename)
        file_date = DatesFromString.new.find_date(_fullpath)
        date_found = !file_date.empty?

        # only organize ones that have a date in the filename
        if date_found == true
          _journal_folder = JournalFolder.new(journal_date: file_date, base_path: base_path)
          _journal_folder.save(filename: _fullpath, noop: dry_run)
        end
      end

      private

      def build_date_path(working_date)
        padded_year   = working_date.year.to_s
        padded_month  = working_date.month.to_s.rjust(2, '0')
        padded_day    = working_date.mday.to_s.rjust(2, '0')

        day_folder    = "#{padded_day} #{Date::ABBR_DAYNAMES[working_date.wday]}"

        folder_path   = File.join(base_path,
                                  padded_year,
                                  padded_month,
                                  day_folder)

        return File.expand_path(folder_path)
      end
    end
  end
end
