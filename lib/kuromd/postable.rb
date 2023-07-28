# frozen_string_literal: true

require 'faraday'
require 'uri'

module Kuromd
  # Post @note_data to a url
  module Postable
    def send(url, note_data)
      uri = URI.parse(url)

      conn = Faraday.new(
        url: "#{uri.scheme}://#{uri.host}",
        params: note_data,
        headers: { 'Content-Type' => 'application/json' }
      )

      Kuromd::logger.info "Sending data to #{uri.path}"
      conn.post(uri.path, '')
    end
  end
end
