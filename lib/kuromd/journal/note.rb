# frozen_string_literal: true

require 'kuromd/basenote'
require 'kuromd/journal/fileable'
# require 'kuromd/journal/folder'

module Kuromd
  module Journal
    # Represents a note for a Journal
    # process method will organize the note into it's
    # base folder
    class Note < Kuromd::BaseNote
      include Fileable

      attr_accessor :params, :base_folder, :file_path, :file_date

      NOTE_TYPE = 'Journal'

      def initialize(params = {})
        super(params)

        @params = @config.params['journal']
        @base_folder = @params['base_folder']

        @file_path = params[:full_path]
        @file_date = @note_data['note_date']

        @note_type = NOTE_TYPE
        Kuromd.logger.info "Journal note initialized: #{@note_data}, #{@params}"
      end

      def valid?
        # needs a title and a note_date
        is_valid = false
        is_valid = !@note_data['title'].nil? && !@note_data['note_date'].nil? if category?

        Kuromd.logger.info "Journal Note object valid? #{is_valid}"
        is_valid
      end

      def process
        return unless valid?

        Kuromd.logger.info "Processing Journal Note: #{@note_data['title']}, #{@note_data['note_date']}"
        journal_folder = create_journal_folder(base_path: @base_folder, date: @file_date)
        new_filename = "#{@note_data['title']}#{::File.extname(@note_path)}"

        copy({ dest_folder: journal_folder,
               source_path: @note_path,
               rename_to: new_filename })
      end
    end
  end
end
