require 'spec_helper'

describe Naka::User do
  let(:owner_id) { "-1" }
  let(:api_token) { "b26300abdeddef99b2192d84d58e5160ac0132d4" }
  let(:api_starttime) { "1377028045350" }
  let(:api_host) { "203.104.105.167" }
  describe :from_request do
    let(:flash_url) { "http://#{api_host}/kcs/mainD2.swf?api_token=#{api_token}&api_starttime=#{api_starttime}" }

    subject { Naka::User.from_request(owner_id, flash_url) }

    its(:id) { should == owner_id.to_i }
    its(:api_host) { should == api_host }
    its(:api_token) { should == api_token }
    its(:api_at) { should == api_starttime.to_i }
  end

  describe :store do
    let(:user) { double(:id => owner_id, :to_hash => {id: owner_id, api_token: api_token}) }
    subject {
      Naka::User.store(user)
      Naka::User.restore(owner_id)
    }
    its(:id) { should == owner_id.to_i }
    its(:api_token) { should == api_token }
  end

  describe :all do
    before do
      Naka::User.store(double(:id => 1, :to_hash => {}))
      Naka::User.store(double(:id => 2, :to_hash => {}))
    end
    subject { Naka::User.all }
    it { should == [1, 2] }
  end
end
