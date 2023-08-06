# frozen_string_literal: true

require 'kuromd/basenote'
require 'kuromd/journal/folder'

module Kuromd
  module Journal
    # Represents a note for a Journal
    # process method will organize the note into it's
    # base folder
    class Note < Kuromd::BaseNote
      attr_accessor :base_folder
      NOTE_TYPE = 'Journal'

      def self.note_type
        NOTE_TYPE
      end

      def note_type
        NOTE_TYPE
      end

      def initialize(params = {})
        super

        Kuromd.logger.info "Journal note initialized: #{@note_data['title']}"
      end

      def valid?
        # needs a note_date and monica_id
        if category?
          is_valid = !@note_data['title'].nil? && !@note_data['note_date'].nil?
        end

        Kuromd.logger.info "Journal Note object valid? #{is_valid}"
        is_valid
      end

      def process
        Kuromd.logger.info "Processing Journal Note: #{@note_data['title']}, #{@note_data['note_date']}"
        folder = Kuromd::Journal::Folder.new({ journal_date: @note_data['note_date'] })
        folder.move(filename: @note_data[:full_path]) if valid?
      end
    end
  end
end
