require 'spec_helper'

describe Naka::Api::Supply do
  describe :supply do
    it 'call api' do
      stub_request(:post, "http://0.0.0.0/kcsapi/api_req_hokyu/charge").
        with(:body => {"api_id_items"=>"1,2", "api_kind"=>"2",
          "api_token"=> "token", "api_verno"=>"1"}).to_return(:status => 200,
        :body => mock_file('api/supply/response.json'))
      user.supply([1, 2], :bullet)
    end
  end
end
