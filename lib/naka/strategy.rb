module Naka
  module Strategies
    class Base
      attr_reader :user

      def self.name(name)
        define_method(:name) { name }
      end

      def initialize(user, options = {})
        @user = user
      end
    end
  end
end

Dir[File.expand_path("../strategies/*", __FILE__)].each { |file| require file }

