require 'spec_helper'

describe Naka::Models::Ship do
  let(:ship) { Naka::Models::Ship.new(MultiJson.load(mock_file('models/ship/ship.json'))) }
  subject { ship }
  its(:id) { should == 23 }
  its(:ship_id) { should == 119 }
  its(:lv) { should == 68 }
  describe :hp do
    subject { ship.hp }
    its(:now) { should == 39 }
    its(:max) { should == 43 }
    its(:damaged?) { should be_true }
  end
  its(:damaged?) { should be_true }
  its(:danger?) { should be_false }
  its(:fuel) { should == 20 }
  its(:bull) { should == 44 }
  its(:locked?) { should be_true }
  its(:repairs_in) { should == 1870 }
  its(:condition) { should == 49 }

  describe Naka::Models::Ship::Hp do
    describe :danger? do
      it { expect(Naka::Models::Ship::Hp.new(11, 21)).not_to be_danger }
      it { expect(Naka::Models::Ship::Hp.new(10, 20)).to be_danger }
    end
  end
end
