require 'spec_helper'

describe Naka::Api::Master::Ship do
  let(:api) { mock_user.api.master.ship }
  describe :all do

    before { Naka.redis.del('naka:master:ships') }
    after { Naka.redis.del('naka:master:ships') }

    it 'call api' do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/ship").to_return(:status => 200, :body => mock_file('api/ships/master.json'), :headers => {})
      ships = mock_user.api.master.ship
      p ships.class
#      expect(ships).to be_a Naka::Models::Master::Ship
    end

    it 'cache result' do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/ship").to_return(:status => 200, :body => mock_file('api/ships/master.json'), :headers => {})
      ships = mock_user.api.master.ship
      #expect(Naka.redis.exists('naka:master:ships')).to be_true
    end
  end
end
