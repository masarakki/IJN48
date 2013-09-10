require 'msgpack'

module Naka
  module Api
    module Master
      class Base < Naka::Api::Base
        class NotFound < ::Exception ; end

        def self.parser
          class_name = self.name.split(/::/).last
          "Naka::Models::Master::#{class_name}".constantize
        end

        def self.cache(val)
          define_method(:keyname) do |*args|
            ([Naka.redis_prefix, "master:#{val}"] + args).join(":")
          end
          private :keyname
        end

        def self.endpoint(val)
          define_method(:endpoint) do
            "/kcsapi/api_get_master/#{val}"
          end

          define_method(:fetch_all) do |*args|
            if self.class.required_args.length == 0
              request endpoint
            else
              hash = Hash[self.class.required_args.map{|x| "api_#{x}".to_sym}.zip(args)]
              raise ArgumentError if hash.any?{|k, v| v.nil? }
              request endpoint, hash
            end
          end
        end

        def self.args(*arg_names)
          arg_names.each {|n| required_args << n }
        end

        def self.required_args
          @required_args ||= []
        end

        def all(*args)
          raise ArgumentError unless args.length == self.class.required_args.length
          cache_keyname = keyname(*args)
          items = Naka.redis.get cache_keyname
          if items
            items = MultiJson.decode(items, :symbolize_keys => true)
          else
            items = fetch_all(*args)
            Naka.redis.set cache_keyname, MultiJson.encode(items)
          end
          self.class.parser.from_api(items)
        end

        def find(*args)
          if args.length == 1
            id = args.first
            begin
              find_without_rescue(id)
            rescue NotFound
              update
              find_without_rescue(id)
            end
          else
          end
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
