require 'spec_helper'

describe Naka::Api::Ships do
  describe :fleets do
    it 'call api' do
      stub_request(:post, "http://#{user.api_host}/kcsapi/api_get_member/deck").
        with(:body => {"api_token" => user.api_token.to_s, "api_verno" => "1"}).
        to_return(:status => 200, :body => mock_file('api/fleets/deck.json'), :headers => {})
      fleets = user.fleets
      expect(fleets.count).to eq 4
    end
  end
end
