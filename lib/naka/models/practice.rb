module Naka
  module Models
    class Practice
      attr_accessor :id, :user_id, :level, :state

      def initialize(options = {})
        options.each_pair do |key, value|
          key = key.to_s.gsub /api_/, ''
          send("#{key}=", value) if respond_to? "#{key}="
        end
      end

      def finished? ; @state != 0 ; end

      def enemy_id=(val) ; @user_id = val ; end
      def enemy_level=(val) ; @level = val ; end
    end
  end
end
