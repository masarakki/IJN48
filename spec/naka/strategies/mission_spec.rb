require 'spec_helper'

describe Naka::Strategies::Mission do
  let(:strategy) { described_class.new(mock_user) }
  describe :missions do
    before { Naka::Api::Status.any_instance.stub(:materials) { materials } }
    subject { strategy.missions.map(&:id).sort }
    context 'some quest accepted' do
      let(:materials) { Naka::Models::Materials.new(200000, 0, 200000, 200000, 100, 100, 100) }
      before { strategy.instance_variable_set(:@accept_ids, [1]) }
      it 'choice quick missions' do
        expect(subject).to eq [1, 2, 5]
      end
    end

    context 'few fuel' do
      let(:materials) { Naka::Models::Materials.new(100, 20000, 20000, 20000, 100, 100, 100) }
      it { expect(subject).to eq [3, 5, 9] }
    end

    context 'few fuel and bullet' do
      let(:materials) { Naka::Models::Materials.new(100, 100, 20000, 20000, 100, 100, 100) }
      it { expect(subject).to eq [2, 3, 5] }
    end

    context 'else' do
      let(:materials) { Naka::Models::Materials.new(25000, 25000, 25000, 25000, 500, 500, 500) }
      it { expect(subject).to eq [2, 4, 10] }
    end
  end
end
