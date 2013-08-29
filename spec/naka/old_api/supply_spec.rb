require 'spec_helper'

describe Naka::OldApi::Supply do
  describe :supply do
    it 'call api' do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_req_hokyu/charge").
        with(:body => {"api_id_items"=>"1,2", "api_kind"=>"2",
          "api_token"=> mock_user.api_token, "api_verno"=>"1"}).to_return(:status => 200,
        :body => mock_file('api/supply/response.json'))
      mock_user.supply([1, 2], :bullet)
    end
  end
end
