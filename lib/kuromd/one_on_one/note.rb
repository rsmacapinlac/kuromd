# frozen_string_literal: true

require 'kuromd/basenote'
require 'kuromd/postable'

module Kuromd
  module OneOnOne
    # Represents a note for a 1:1
    class Note < Kuromd::BaseNote
      include Postable

      attr_accessor :params, :note_data, :note_path, :one_on_one_url
      NOTE_TYPE = 'One on one'

      def initialize(params = {})
        super(params)
        # config = Kuromd::Configurable.get_config
        # @params = config.params['notes']['one_on_one']
        @params = @config.params['notes']['one_on_one']

        @note_type = NOTE_TYPE
        Kuromd.logger.info "One on one note initialized: #{@note_data}, #{@params}"
      end

      def valid?
        is_valid = false

        # has to have the category
        if category?
          # needs a note_date and monica_id
          is_valid = (!@note_data['note_date'].nil? && !@note_data['note_date'].empty?) &&
                     !@note_data['monica_id'].nil? &&
                     !@note_data['title'].nil?
        end

        Kuromd.logger.info "One on One note object valid? #{is_valid}"
        is_valid
      end

      def process
        return unless valid?

        url = @params['url']
        Kuromd.logger.info "Processing One on one note: #{@note_data['title']}, #{@note_data['note_date']} to #{url}"

        # Invoke Kuromd::Note::Postable's send method
        send(url, @note_data)
      end
    end
  end
end
