# frozen_string_literal: true

require 'net/http'
require 'uri'

require_relative 'spectrum/version'
require_relative 'spectrum/router'

module Spectrum
  def self.posts(channel, page: 1, sort: :newest, logger: nil)
    logger.debug "Getting posts for #{channel}, page #{page}, sort by #{sort}" if logger
    JSON.parse(http.post("/api/spectrum/forum/channel/threads", { channel_id: channel.to_s, page: page, sort: sort }.to_json, { 'content-type' => 'application/json' }).body)
  end

  class << self
    private

    def http
      @http ||= Net::HTTP.new('robertsspaceindustries.com', 443)
      @http.use_ssl = true
      @http.start unless @http.started?

      yield @http if block_given?
      @http
    end
  end
end
