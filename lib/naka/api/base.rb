require 'forwardable'

module Naka
  module Api
    class Base
      extend Forwardable

      attr_reader :user, :client

      def initialize(user)
        @user = user
        @client = Client.new(user)
      end

      def_delegator :@client, :post, :request
    end
  end
end
