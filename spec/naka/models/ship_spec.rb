# -*- coding: utf-8 -*-
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

  describe :consumed? do
    context :equals do
      before { ship.master = OpenStruct.new(:fuel => 20, :bullet => 44) }
      it { should_not be_consumed }
    end
    context :used do
      before { ship.master = OpenStruct.new(:fuel => 20, :bullet => 45) }
      it { should be_consumed }
    end
  end

  describe :pure_name do
    it '千代田甲 should eq 千代田' do
      ship.master = OpenStruct.new(name: '千代田甲')
      expect(ship.pure_name).to eq '千代田'
    end
    it '大井改二 should eq 大井' do
      ship.master = OpenStruct.new(name: '大井改二')
      expect(ship.pure_name).to eq '大井'
    end
    it '電改 should eq 電' do
      ship.master = OpenStruct.new(name: '電改')
      expect(ship.pure_name).to eq '電'
    end
  end

  describe Naka::Models::Ship::Hp do
    describe :danger? do
      it { expect(Naka::Models::Ship::Hp.new(11, 21)).not_to be_danger }
      it { expect(Naka::Models::Ship::Hp.new(10, 20)).to be_danger }
      it { expect(Naka::Models::Ship::Hp.new(8, 30)).not_to be_fatal }
      it { expect(Naka::Models::Ship::Hp.new(7, 30)).to be_fatal }
    end
  end

  describe :factories do
    describe :damaged do
      subject { build(:ship, :damaged) }
      it { should be_damaged }
      it { should_not be_danger }
    end
    describe :fatal_damaged do
      subject { build(:ship, :fatal_damaged) }
      it { should be_damaged }
      it { should be_danger }
    end
    describe :damaged_and_tired do
      subject { build(:ship, :damaged, :tired) }
      it { should be_danger }
    end
  end
end
