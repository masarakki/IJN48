# -*- coding: utf-8 -*-

module Naka
  module Models
    class Materials

      class Material
        include Comparable
        attr_accessor :counter
        attr_reader :id, :name, :type

        def initialize(id, name, type, counter = 0)
          @id = id
          @name = name
          @type = type
          @counter = counter
        end

        def item? ; type == :item ; end
        def material? ; type == :material ; end

        def <=>(other)
          return counter <=> other if other.is_a?(Integer)
          return counter <=> other.counter if other.is_a?(Material)
        end
      end

      def initialize(*nums)
        self.class.keys.zip(nums) do |key, value|
          self.send("#{key}=", value)
        end
      end

      def method_missing(name, *args, &block)
        if @_materials.values.respond_to?(name)
          self.class.send(:define_method, name) do |*new_args, &new_block|
            @_materials.values.send(name, *new_args, &new_block)
          end
          send(name, *args, &block)
        else
          super(name, *args, &block)
        end
      end

      private
      def self.keys
        [:fuel, :bullet, :steel, :bauxite, :ship, :repair, :creator]
      end

      self.keys.each do |key|
        define_method("#{key}=") do |num|
          _materials[key].counter = num
        end
        define_method(key) do
          _materials[key]
        end
      end

      def _materials
        @_materials ||= {
          fuel: Material.new(:fuel, "燃料", :material),
          bullet: Material.new(:bullet, "弾薬", :material),
          steel: Material.new(:steel, "鋼材", :material),
          bauxite: Material.new(:bauxite, "ボーキサイト", :material),
          ship: Material.new(:ship, "高速建造材", :item),
          repair: Material.new(:repair, "高速修復材", :item),
          creator: Material.new(:creator, "開発資材", :item)
        }
      end
    end
  end
end
