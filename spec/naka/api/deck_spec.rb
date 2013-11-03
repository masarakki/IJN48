require 'spec_helper'

describe Naka::Api::Deck do
  let(:api) { mock_user.api.deck }

  describe :organize do
    let(:fleet) do
      Naka::Models::Fleet.new.tap do |fleet|
        fleet.id = 1
        fleet.ship_ids = [100, 101, 102]
      end
    end
    before do
      mock_user.stub(:fleets) { [ fleet ] }
    end
    subject { api.organize(1, [double(:id => 3)]) }
    it 'remove 2 ships, change flagship' do
      api.should_receive(:change).with(1, 0, 3)
      api.should_receive(:remove).with(1, 1).twice
      subject
    end
  end
end
