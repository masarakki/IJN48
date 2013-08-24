module Naka
  module Models
    class Dock
      attr_accessor :id, :member_id, :state, :ship_id, :repairs_at
      def initialize(options = {})
        options.each_pair do |key, value|
          key = key.to_s.gsub /api_/, ''
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def used? ; @used ; end
      def blank? ; !@used ; end
      def repairs_in
        return nil if blank?
        repairs_at - Time.now
      end

      def ship_id=(val) ; @ship_id = val unless val == 0 ; end
      def state=(val) ; @used = val == true || val == 1 ; end
      def complete_time=(val) ; @repairs_at = Time.at(val / 1000) unless val == 0 ; end

      def api_state=(val) ; @used = val == 1; end
      def api_complete_time=(val) ; @repairs_at = Time.at(val / 1000) unless val == 0 ; end
    end
  end
end
