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
    subject {
      Naka::User.store(mock_user)
      Naka::User.find(mock_user.id)
    }
    its(:id) { should == mock_user.id }
    its(:api_token) { should == mock_user.api_token }
  end

  describe :all do
    before do
      Naka::User.store(build(:user, :id => 1))
      Naka::User.store(build(:user, :id => 2))
    end
    subject { Naka::User.all.map(&:id).sort }
    it { should == [1, 2].sort }
  end

  describe :find do
    let(:user) { build(:user, :id => 1024) }
    before { Naka::User.store(user) }
    subject { Naka::User.find(1024).to_hash }
    it { should == user.to_hash }
  end
end
