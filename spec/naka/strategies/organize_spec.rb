require 'spec_helper'

describe Naka::Strategies::Organize do
  describe :default do
    let(:strategy) { described_class.new(mock_user) }
    subject { strategy }
    its(:fleet_id) { should == 1 }
    its(:size) { should == 1 }
    its(:types) { should == [] }
    its(:damaged) { should be_false }
  end
end
