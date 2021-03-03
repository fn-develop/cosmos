require 'json'
require 'net/http'
require 'uri'

module Sms
  class HTTPClient
    attr_accessor :http_options

    def initialize(http_options = {})
      @http_options = http_options
    end

    def http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"
        http.use_ssl = true
      end

      if http_options
        http_options.each do |key, value|
          http.send("#{key}=", value)
        end
      end

      http
    end

    def get(url, header = {})
      uri = URI(url)
      http(uri).get(uri.request_uri, header)
    end

    def post(url, payload, header = {})
      uri = URI(url)
      http(uri).post(uri.request_uri, payload, header)
    end

    def delete(url, header = {})
      uri = URI(url)
      http(uri).delete(uri.request_uri, header)
    end
  end
end
