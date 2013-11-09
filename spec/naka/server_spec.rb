require 'spec_helper'
require 'rack/test'

describe Naka::Server do
  include Rack::Test::Methods

  def app
    Naka::Server
  end

  describe 'POST index' do
    let(:params) { { "url" => "http://203.104.105.167/kcs/mainD2.swf?api_token=b26300abdeddef99b2192d84d58e5160ac0132d4&api_starttime=1377028045350", "owner_id" => "10732601" } }

    it '200 ok' do
      post '/', params
      expect(last_response).to be_ok
    end
  end
end
