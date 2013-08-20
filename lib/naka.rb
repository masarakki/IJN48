require 'naka/server'
require 'naka/user'
require 'redis'

module Naka
  def self.redis
    @redis ||= Redis.connect
    @redis.client.reconnect unless @redis.client.connected?
    @redis
  end
end
