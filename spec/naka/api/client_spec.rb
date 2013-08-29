require 'spec_helper'

describe Naka::Api::Client do
  let(:client) { Naka::Api::Client.new(mock_user) }

  it 'with default parameters' do
    stub_request(:any, /.*/).with(body: {
        "api_token" => mock_user.api_token, "api_verno" => "1", "hello" => "world"
      }).to_return(status: 200, body: 'svdata={"api_result": 1}')
    response = client.post '/test', hello: 'world'
    expect(response).to have_key :api_result
    expect(response[:api_result]).to eq 1
  end

  it 'with default headers' do
    stub_request(:any, /.*/).with(headers: {
        'Accept-Encoding' => 'gzip, deflate, sdch',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Host' => mock_user.api_host,
        'Origin' => "http://#{mock_user.api_host}",
        'Referer' => "http://#{mock_user.api_host}/kcs/mainD2.swf?api_token=#{mock_user.api_token}&api_starttime=#{mock_user.api_at}"
      }).to_return(status: 200, body: 'svdata={"api_result": 1}')
    response = client.post '/test', hello: 'world'
    expect(response).to have_key :api_result
    expect(response[:api_result]).to eq 1
  end

  it 'raise if response is not a json' do
    stub_request(:any, /.*/).to_return(status: 200, body: 'svdata=[}[},unko')
    expect {
      client.post '/test'
    }.to raise_error
  end

  it 'raise if api_result is not 1' do
    stub_request(:any, /.*/).to_return(status: 200, body: 'svdata={"api_result": 100}')
    expect {
      client.post '/test'
    }.to raise_error
  end
end
