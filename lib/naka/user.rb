require 'cgi'
require 'pry'
module Naka
  class User
    attr_reader :id, :api_host, :api_token, :api_at

    def self.from_request(owner_id, flash_url)
      uri = URI.parse(flash_url)
      host = uri.host
      query = CGI.parse(uri.query)
      api_token = query["api_token"].first
      api_starttime = query["api_starttime"].first

      self.new.instance_eval do
        @id = owner_id.to_i
        @api_host = host
        @api_token = api_token
        @api_at = api_starttime.to_i
        self
      end
    end
  end
end
