require 'spec_helper'

describe Naka::Api::Docks do
  it 'call api' do
    stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_member/ndock").
      with(:body => {"api_token" => mock_user.api_token.to_s, "api_verno" => "1"}).
      to_return(:status => 200, :body => mock_file('api/docks/response.json'), :headers => {})
    docks = mock_user.docks
    expect(docks.count).to eq 4
  end
end
