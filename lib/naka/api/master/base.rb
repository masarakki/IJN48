require 'msgpack'

module Naka
  module Api
    module Master
      class Base < Naka::Api::Base
        class NotFound < ::Exception ; end

        def self.cache(val)
          define_method(:keyname) { [Naka.redis_prefix, "master:#{val}"].join(":") }
          private :keyname
        end

        def self.endpoint(val)
          define_method(:fetch_all) do
            request "/kcsapi/api_get_master/#{val}"
          end
          private :fetch_all
        end

        def all
          return @all if @all
          items = Naka.redis.get keyname
          if items
            items = MessagePack.unpack(items)
          else
            items = update
          end
          @all = items.map{|x| OpenStruct.new(x) }
        end

        def find(id)
          find_without_rescue(id)
        rescue NotFound
          update
          find_without_rescue(id)
        end

        private
        def find_without_rescue(id)
          item = all.detect{|x| x.id == id}
          raise NotFound unless item
          item
        end

        def update

        end
      end
    end
  end
end
