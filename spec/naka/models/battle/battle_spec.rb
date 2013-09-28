require 'spec_helper'

describe Naka::Models::Battle::Battle do
  def mock_battle(file)
    stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_req_sortie/battle").
      to_return(status: 200, body: mock_file("api/battle/battle/#{file}.json"))
  end

  let(:battle) { mock_user.api.battle.battle }
  subject { battle }
  context :complete do
    before { mock_battle('complete') }
    it { should be_a described_class }
    it { should be_completed }
    its(:enemy_ids) { should == [506, 502, 502] }
  end

  context :not_complete do
    before { mock_battle('not_complete') }
    it { should be_a described_class }
    it { should_not be_completed }
    its(:enemy_ids) { should == [506, 508, 503, 503, 502] }
    its(:fleet_hps) { should == [[27, 32], [25, 31], [55, 55]] }
    its(:enemy_hps) { should == [[0, 36], [0, 48], [0, 24], [24, 24], [0, 22]] }
  end

  context '3vs2' do
    before { mock_battle('3vs2') }
    it { should be_a described_class }
    its(:enemy_ids) { should == [501, 501] }
    its(:enemy_hps) { should == [[0, 20], [0, 20]] }
    its(:fleet_hps) { should == [[31, 31], [30, 30], [31, 31]] }
  end

  context 'fire twice' do
    before { mock_battle('bb') }
    it { should be_a described_class }
    its(:fleet_hps) { should == [[75, 75], [69, 75], [75, 75]] }
    its(:enemy_hps) { should == [[0, 60], [0, 50], [0, 48], [0, 48], [0, 24], [0, 24]] }
  end

  context 'start with cv' do
    before { mock_battle('cv') }
    its(:enemy_hps) { should == [[0, 22]] }
  end

  context 'start with torpedo' do
    before { mock_battle('torpedo_start') }
    it { should be_a described_class }
    its(:enemy_hps) { should == [[0, 24]] }
  end

  context 'finish with torpedo' do
    before { mock_battle('torpedo_last') }
    its(:enemy_hps) { should == [[33, 33], [0, 20], [0, 20]] }
    its(:fleet_hps) { should == [[30, 37]] }
  end

  describe 'compatible with practice' do
    before do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_req_practice/battle").
        to_return(status: 200, body: mock_file("api/user/practice/battle.json"))
    end
    let(:battle) { mock_user.api.user.practice.battle(double(user_id: 1)) }
    it { should be_a described_class }
    its(:enemy_hps) { should == [[0, 75]] }
    it { should be_completed }
  end
end
