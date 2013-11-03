# -*- coding: utf-8 -*-
require 'forwardable'

module Naka
  module Models
    class Ship
      extend Forwardable

      def_delegators :master, :name, :type

      Hp = Struct.new(:now, :max) do
        def damaged? ; now != max ; end
        def danger? ; now * 2 <= max ; end
        def fatal? ; now * 4 <= max ; end
      end

      attr_accessor :id, :ship_id, :lv, :fuel, :bull, :hp, :repairs_in, :condition, :master

      def initialize(options = {})
        @hp = Hp.new
        options.each_pair do |key, value|
          key = key.to_s.gsub /api_/, ''
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def pure_name
        name = @master.name
        return '千歳' if name =~ /^千歳/
        return '千代田' if name =~ /^千代田/
        name.gsub /改二?$/, ''
      end

      def bullet ; @bull ; end
      def locked? ; @locked ; end
      def damaged? ; @hp.damaged? ; end
      def high? ; @condition >= 50 ; end
      def good? ; @condition >= 40 ; end
      def tired? ; @condition < 30 ; end
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
