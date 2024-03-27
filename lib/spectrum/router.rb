# frozen_string_literal: true

require 'nokogiri'
require 'sinatra/base'

class Spectrum::Router < Sinatra::Base
  set :public_folder, File.join(__dir__, '..', 'public')

  get '/' do
    Nokogiri::HTML::Builder.new do |xml|
      xml.html do
        xml.head do
          xml.title "RSI Spectrum RSS"
        end
        xml.body do
          xml.p "RSI Spectrum RSS converter - v#{Spectrum::VERSION}"
        end
      end
    end.to_html
  end

  get '/:channel/feed.xml', provides: %w[rss atom xml] do |channel|
    posts = Spectrum.posts(channel, logger: logger)
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.feed(xmlns: 'http://www.w3.org/2005/Atom') do
        xml.id "rsi:spectrum:#{channel}"
        xml.title "Spectrum posts for channel #{channel}", type: :text
        xml.link href: "https://robertsspaceindustries.com/spectrum/community/SC/forum/#{channel}", rel: :alternate
        xml.updated Time.at(posts.dig('data', 'latest_timestamp')).strftime("%FT%TZ")

        xml.generator('RSI Spectrum RSS', version: Spectrum::VERSION)

        posts.dig('data', 'threads').each do |thread|
          post_uri = "https://robertsspaceindustries.com/spectrum/community/SC/forum/#{channel}/thread/#{thread['slug']}"
          xml.entry do
            xml.id "spectrum:#{channel}:#{thread['id']}"
            xml.title thread['subject']
            xml.link href: post_uri, rel: :alternate
            xml.published Time.at(thread['time_created']).strftime('%FT%TZ')
            xml.updated Time.at(thread['time_modified']).strftime('%FT%TZ')
            author = thread['member']
            xml.author do
              xml.name author['displayname']
            end
          end
        end
      end
    end.to_xml
  end
end
