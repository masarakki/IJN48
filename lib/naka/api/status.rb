module Naka
  module Api
    class Status < Naka::Api::Base
      def materials
        response = request '/kcsapi/api_get_member/material'
        Naka::Models::Materials.new(*response[:api_data].map{|x| x[:api_value]})
      end
    end

    Manager.register :status, Status
  end
end
