require 'spec_helper'

describe Naka::Models::Base do
  describe :collection_methods do
    it 'inner collection should receive' do
      described_class.collection << 1 << 2
      expect(described_class.length).to eq 2
      expect(described_class.any?{|x| x == 1 }).to be_true
      expect(described_class.any?{|x| x == 100}).to be_false
    end
    it 'raise unless collection has method' do
      expect { described_class.hogehoge }.to raise_error(NoMethodError)
    end
  end
end
