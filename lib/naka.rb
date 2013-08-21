require 'naka/server'
require 'naka/user'
require 'naka/models'
require 'naka/api'
require 'redis'

module Naka
  def self.redis
    @redis ||= Redis.connect
    @redis.client.reconnect unless @redis.client.connected?
    @redis
  end
end
