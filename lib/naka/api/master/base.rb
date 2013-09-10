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
          define_method(:keyname) { [Naka.redis_prefix, "master:#{val}"].join(":") }
          private :keyname
        end

        def self.endpoint(val)
          define_method(:endpoint) do
            "/kcsapi/api_get_master/#{val}"
          end

          define_method(:fetch_all) do |*args|
            if self.class.required_args == []
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
          if args.length == 0
            return @all if @all
            items = Naka.redis.get keyname
            if items
              items = MessagePack.unpack(items)
            else
              items = update
            end
            @all = items.map{|x| OpenStruct.new(x) }
          else
            items = fetch_all(*args)
            self.class.parser.from_api(items)
          end
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
