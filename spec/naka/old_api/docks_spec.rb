require 'spec_helper'

describe Naka::OldApi::Docks do
  it 'call api' do
    docks = mock_user.docks
    expect(docks.count).to eq 4
  end
end
