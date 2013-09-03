# -*- coding: utf-8 -*-
module Naka
  module Models
    class Deck
      attr_accessor :id, :name, :ships

      def has_submarine?
        ships.any?{|x| ["潜水艦", "潜水母艦"].include?(x.master.type) }
      end
    end
  end
end
