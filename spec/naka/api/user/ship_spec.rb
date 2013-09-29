require 'spec_helper'

describe Naka::Api::User::Ship do
  let(:api) { mock_user.api.user.ship }

  describe :all do
    before do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_member/ship2").
        to_return(:body => mock_file('api/ships/response.json'))
    end

    it "fetch all" do
      ships = api.all
      expect(ships.count).to eq 83
    end
  end
end
