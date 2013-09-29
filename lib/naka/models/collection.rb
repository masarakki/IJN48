module Naka
  module Models
    module Collection < Array
      def find(id)
        detect{|x| x.id == id}
      end
    end
  end
end
