# frozen_string_literal: true

require 'fileutils'

module Kuromd
  module Journal
    # represents an Inbox folder
    class Inbox
      def initialize(inbox_path:)
        raise 'Inbox path required' if inbox_path.nil? == true

        @inbox_fullpath = File.expand_path(inbox_path)
        @created = File.exist?(@inbox_fullpath)
      end

      # creates the inbox folder (if it isn't created)
      def create
        FileUtils.mkdir_p @inbox_fullpath if @created == false
        @created = true
      end

      # list files in the inbox folder
      def ls
        Dir[@inbox_fullpath]
      end

      def save(filename:, journal_date: Date.today)
        _filename = File.expand_path(filename)
        _basename = File.basename _filename
        inbox_filename = "#{journal_date} - #{_basename}"
        dest_file = File.join(@inbox_fullpath, inbox_filename)
        FileUtils.mv _filename, dest_file
      end
    end
  end
end
