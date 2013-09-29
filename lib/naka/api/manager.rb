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
        def register(name, api, direct = false)
          define_method(name) do |*args|
            val = instance_variable_get("@_api_#{name}")
            unless val
              val = api.new(@user)
              val = val.all(*args) if direct
              instance_variable_set("@_api_#{name}", val)
            end
            val
          end
        end
      end
    end
  end
end
