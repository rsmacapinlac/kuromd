# frozen_string_literal: true

require 'kuromd/configurable'
require 'kuromd/note/note'
require 'kuromd/note/postable'

module Kuromd
  module Note
    # Represents a note for a 1:1
    class OneOnOne < Note
      include Configurable
      include Postable

      attr_accessor :params, :note_data, :note_path, :one_on_one_url

      def initialize(params = {})
        super
        config = Kuromd::Configurable.get_config
        @params = config.params['one_on_one']
      end

      def valid?
        # needs a note_date and monica_id
        !@note_data['note_date'].nil? && !@note_data['monica_id'].nil?
      end
      
      def process
        # puts valid?
        url = @params['url']

        # Invoke Kuromd::Note::Postable's send method
        send(url, @note_data) if valid?
      end
    end
  end
end
