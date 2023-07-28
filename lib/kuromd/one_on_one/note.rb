# frozen_string_literal: true

require 'kuromd/configurable'
require 'kuromd/basenote'
require 'kuromd/postable'

module Kuromd
  module OneOnOne
    # Represents a note for a 1:1
    class Note < Kuromd::BaseNote
      include Configurable
      include Postable

      attr_accessor :params, :note_data, :note_path, :one_on_one_url

      def initialize(params = {})
        super
        config = Kuromd::Configurable.get_config
        @params = config.params['one_on_one']
        Kuromd.logger.info "One on one note initialized: #{@params}"
      end

      def valid?
        # needs a note_date and monica_id
        is_valid = !@note_data['note_date'].nil? &&
          !@note_data['monica_id'].nil? &&
          !@note_data['title'].nil?

        Kuromd::logger.info "One on One Note object valid? #{is_valid}"
        is_valid
      end
      
      def process
        Kuromd::logger.info "Processing: #{@note_data['title']}, #{@note_data['note_date']}"
        url = @params['url']

        # Invoke Kuromd::Note::Postable's send method
        send(url, @note_data) if valid?
      end
    end
  end
end
