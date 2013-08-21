require 'cgi'
require 'msgpack'

module Naka
  class User
    attr_reader :id, :api_host, :api_token, :api_at

    def initialize(options = {})
      @id = options[:id].to_i
      @api_host = options[:api_host]
      @api_token = options[:api_token]
      @api_at = options[:api_at].to_i
    end

    def self.from_request(owner_id, flash_url)
      uri = URI.parse(flash_url)
      host = uri.host
      query = CGI.parse(uri.query)
      api_token = query["api_token"].first
      api_starttime = query["api_starttime"].first

      new(id: owner_id, api_host: host, api_token: api_token, api_at: api_starttime)
    end

    def to_hash
      [:id, :api_host, :api_token, :api_at].inject({}) { |res, key| res[key] = self.send(key) ; res }
    end

    def store
      self.class.store(self)
    end

    class << self
      def store(record)
        Naka.redis.set(redis_key(record.id), record.to_hash.to_msgpack)
      end

      def restore(id)
        hash  = MessagePack.unpack(Naka.redis.get(redis_key(id)))
        new OpenStruct.new(hash).to_h
      end

      def all
        keys.map {|key| key.split(/:/).last.to_i }.sort
      end

      def remove(id)
        Naka.redis.del(redis_key(id))
      end

      private
      def keys
        Naka.redis.keys [namespace, "*"].join(":")
      end

      def redis_key(id)
        [namespace, id].join(":")
      end

      def namespace
        "ijn48:naka:user"
      end

      def clean
        all.each {|id| remove id }
      end
    end
  end
end
