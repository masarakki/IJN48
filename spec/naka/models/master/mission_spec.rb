require 'spec_helper'

describe Naka::Models::Master::Mission do
  context :id_1 do
    subject { Naka::Models::Master::Mission.find(1) }
    its(:id) { should == 1 }
    its("cost.to_h") { should == {fuel: 0.3, bullet: 0}}
    its("reward.to_h") { should == {fuel: 0, bullet: 30, steel: 0, bauxite: 0, repair: 0}}
    its(:time) { should == 15 }
    its(:fleet) { should == {any: 2} }
  end
end
