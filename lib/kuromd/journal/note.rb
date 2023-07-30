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

      def initialize(params = {})
        super
        config = Kuromd::Configurable.get_config
        @params = config.params['journal']

        @base_folder = @params['base_folder']
        @base_folder = File.expand_path @base_folder

        Kuromd.logger.info "Journal note initialized: #{@params}"
      end

      def valid?
        # needs a note_date and monica_id
        is_valid = !@note_data['title'].nil? &&
                   !@note_data['note_date'].nil?

        Kuromd.logger.info "Journal Note object valid? #{is_valid}"
        is_valid
      end

      def process
        Kuromd.logger.info 'Processing Journal Note'
        folder = Kuromd::Journal::Folder.new({ base_path: @base_folder,
                                               journal_date: @note_data['note_date'] })
        folder.move(filename: @note_data[:full_path]) if valid?
      end
    end
  end
end
