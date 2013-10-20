require 'spec_helper'

describe Naka::Models::Materials do
  subject { described_class.new(100, 200, 300, 400, 500, 600, 700) }
  its(:fuel) { should eq 100 }
  its(:bullet) { should eq 200 }
  its(:steel) { should eq 300 }
  its(:bauxite) { should eq 400 }
  its(:ship) { should eq 500 }
  its(:repair) { should eq 600 }
  its(:creator) { should eq 700 }
  its("creator.id") { should == :creator }
  it { expect(subject.fuel).to be < subject.bullet }

  it 'enumerable' do
    expect(subject.select{|x| x.counter < 400}.count).to eq 3
    expect(subject.select.count).to eq 7
    expect(subject.select{|x| x.type == :material}.count).to eq 4
  end
end
