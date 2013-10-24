require 'spec_helper'

describe Naka::Models::Battle::MidnightBattle do
  def mock_battle(file)
    stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_req_battle_midnight/sp_midnight").
      to_return(status: 200, body: mock_file("api/battle/midnight_battle/#{file}.json"))
  end

  let(:battle) { mock_user.api.battle.midnight_battle }
  subject { battle }
  context :battle do
    before { mock_battle('battle') }
    it { should be_a described_class }
    it { should be_completed }
    its(:enemy_ids) { should == [543, 527, 527, 555, 552, 552] }
    its(:fleet_hps) { should == [[31, 31], [33, 43], [31, 31], [43, 43], [75, 75], [68, 75]] }
    its(:enemy_hps) { should == [[0, 90], [0, 76], [0, 76], [0, 57], [0, 43], [0, 43]] }
  end
end
