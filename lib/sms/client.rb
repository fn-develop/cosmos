require 'base64'
require 'net/http'
require 'openssl'
require 'uri'

module Sms
  # API Client of Sms SDK Ruby
  #
  #   @client ||= Sms::Client.new do |config|
  #     config.company = xxx
  #   end
  class Client

    attr_accessor :company, :send_endpoint

    attr_accessor :httpclient

    def initialize
      yield(self) if block_given?
    end

    def httpclient
      @httpclient ||= HTTPClient.new
    end

    def send_endpoint
      @send_endpoint ||= "#{AppSetting.first.try(:sms_send_api_url)}"
    end

    def send_message(tel_number, message, headers: {})
      return unless self.company.is_sms_feature?
      url = send_endpoint + from_tel_number_params + '&number=' + tel_number + '&message=' + message
      url = URI.encode(url)
      get(url, headers = {})
    end

    def from_tel_number_params
      "&snddoco=#{self.company.sms_tel_number}&sndemob=#{self.company.sms_tel_number}&sndkddi=#{self.company.sms_tel_number}"
    end

    # Fetch data, get content of specified URL.
    #
    # @param endpoint_url [String]
    # @param headers [Hash]
    #
    # @return [Net::HTTPResponse]
    def get(endpoint_url, headers = {})
      headers = API::DEFAULT_HEADERS.merge(headers)
      httpclient.get(endpoint_url, headers)
    end
  end

end
