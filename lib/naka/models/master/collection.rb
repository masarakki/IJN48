module Naka
  module Models
    module Master
      class Collection < Array
        def find(id)
          detect{|x| x.id == id }
        end
      end
    end
  end
end
