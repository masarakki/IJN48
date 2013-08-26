module Naka
  module Models
    class Ship
      Hp = Struct.new(:now, :max) do
        def damaged? ; now != max ; end
        def danger? ; now * 2 <= max ; end
      end

      attr_accessor :id, :ship_id, :lv, :fuel, :bull, :hp, :repairs_in, :condition, :master

      def initialize(options = {})
        @hp = Hp.new
        options.each_pair do |key, value|
          key = key.to_s.gsub /api_/, ''
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def bullet ; @bull ; end
      def locked? ; @locked ; end
      def damaged? ; @hp.damaged? ; end
      def tired? ; @condition <= 30 ; end
      def danger? ; tired? || hp.danger? ; end
      def consumed? ; ! (master.bullet == bullet && master.fuel == fuel) ; end

      def nowhp=(val) ; @hp.now = val ; end
      def maxhp=(val) ; @hp.max = val ; end
      def locked=(val) ; @locked = val == 1 ; end
      def ndock_time=(val) ; @repairs_in = val / 1000 ; end
      def cond=(val) ; @condition = val ; end
    end
  end
end
