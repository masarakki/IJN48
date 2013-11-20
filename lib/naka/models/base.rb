module Naka
  module Models
    class Base
      attr_accessor :id

      def self.collection
        @collection ||= []
      end

      def self.register(item)
        item = self.new(item) unless item.is_a? self
        collection << item unless find(item.id)
      end

      class << self
        def method_missing(*args, &block)
          method_name = args.first
          if collection.respond_to? method_name
            define_singleton_method(method_name) do |*method_args, &block|
              collection.send(method_name, *method_args, &block)
            end
            send(*args, &block)
          else
            super(*args, &block)
          end
        end
      end

      def self.find(id)
        collection.detect{|x| x.id == id}
      end
    end
  end
end
