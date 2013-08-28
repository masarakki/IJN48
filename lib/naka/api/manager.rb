require 'forwardable' # TODO: remove it!
module Naka
  module Api
    class Manager
      extend Forwardable # TODO: remove it !
      def initialize(user)
        @user = user
        @client = Naka::Api::Client.new(@user) # TODO: remove it !
      end

      def_delegators :@client, :post, :post # TODO: remove it!

      class << self
        def register(name, api)
          define_method(name) do
            val = instance_variable_get("@#{name}")
            unless val
              val = api.new(@user)
              instance_variable_set("@#{name}", val)
            end
            val
          end
        end
      end
    end
  end
end
