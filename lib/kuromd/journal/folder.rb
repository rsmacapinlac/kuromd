# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'dates_from_string'

module Kuromd
  module Journal
    # Given a date and a base path, this object will create a place to file
    # a journal item
    class Folder
      include Configurable

      attr_accessor :created, :journal_date, :base_path
      attr_reader   :full_day_path

      def initialize(params = {})
        raise 'Params required' if params.nil? == true

        # TODO: If there is an existing configuration, use that configuration file
        @config = Kuromd::Configurable.get_config

        # @base_path is required will throw KeyError if not found
        @base_path    = @config.params['journal']['base_folder']
        @journal_date = params[:journal_date]

        @full_day_path = build_date_path(Date.parse(@journal_date.to_s))
        @created = Dir.exist?(@full_day_path)
      end

      def create
        FileUtils.mkdir_p @full_day_path if @created == false
        @created = true
      end

      def move(filename:)
        fullpath = File.expand_path(filename)
        create if @created == false

        file_date = DatesFromString.new.find_date(filename)[0]
        file_date = '' if file_date.nil?

        file_to_move = File.basename(fullpath)
        if file_to_move.index(file_date).zero? && !file_date.empty?
          # date was found in the beginning of the string, assume it follows
          # format: date - filename.ext
          file_to_move = file_to_move.delete_prefix("#{file_date} - ")
        end
        dest = File.join(@full_day_path, file_to_move)
        Kuromd.logger.info "Move: #{fullpath} to #{dest}" if FileUtils.mv fullpath, dest
      end

      private

      def build_date_path(working_date)
        puts working_date
        padded_year   = working_date.year.to_s
        padded_month  = working_date.month.to_s.rjust(2, '0')
        padded_day    = working_date.mday.to_s.rjust(2, '0')

        day_folder    = "#{padded_day} #{Date::ABBR_DAYNAMES[working_date.wday]}"

        folder_path   = File.join(@base_path,
                                  padded_year,
                                  padded_month,
                                  day_folder)

        File.expand_path(folder_path)
      end
    end
  end
end
