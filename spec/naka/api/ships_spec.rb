require 'spec_helper'

describe Naka::Api::Ships do
  describe :ships do
    before { user.stub(:ships_master) { FactoryGirl.build_list(:ship_master, 100) } }
    it 'call api' do
      stub_request(:post, "http://#{user.api_host}/kcsapi/api_get_member/ship2").
        with(:body => {"api_sort_key" => "1", "api_sort_order" => "2", "api_token" => user.api_token.to_s, "api_verno" => "1"},
        :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate, sdch',
          'Content-Length'=>'59','Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby', 'Referer' => 'http://0.0.0.0/kcs/mainD2.swf?api_token=token&api_starttime=0', 'Origin' => "http://#{user.api_host}", 'Host' => user.api_host}).
        to_return(:status => 200, :body => mock_file('api/ships/response.json'), :headers => {})
      ships = user.ships
      expect(ships.count).to eq 83
    end
  end

  describe :ships_master do
    before { Naka.redis.del('naka:master:ships') }
    after { Naka.redis.del('naka:master:ships') }

    it 'call api' do
      stub_request(:post, "http://0.0.0.0/kcsapi/api_get_master/ship").to_return(:status => 200, :body => mock_file('api/ships/master.json'), :headers => {})
      user.ships_master
    end
    it 'cache result' do
      stub_request(:post, "http://0.0.0.0/kcsapi/api_get_master/ship").to_return(:status => 200, :body => mock_file('api/ships/master.json'), :headers => {})
      user.ships_master
      expect(Naka.redis.exists('naka:master:ships')).to be_true
    end
  end
end
