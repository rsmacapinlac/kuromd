# frozen_string_literal: true

module Kuromd
  module Note
    # Super class for all Notes
    class Note
      def initialize(params = {})
        raise 'Params required' if params.nil?

        @note_data = params[:note_data]

        # ensure path is absolute
        @note_path = @note_data[:full_path]
        @note_path = File.expand_path(@note_path)
      end

      def self.categorize(params = {})
        note_data = params[:note_data]
        note_type = note_data['note_type']

        Kuromd::Note::OneOnOne.new({ note_data: }) if note_type == 'One on one'
      end

      def valid?; end
      def process; end
    end
  end
end
