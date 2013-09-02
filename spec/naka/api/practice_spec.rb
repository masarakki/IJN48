require 'spec_helper'

describe Naka::Api::Practice do
  let(:api) { mock_user.api.practice }
  let(:practice) { double(user_id: 1) }
  describe :all do
    before do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_member/practice").to_return(
        :status => 200, :body => mock_file('api/practice/all.json'))
    end

    describe :first do
      subject { api.all.first }
      its(:id) { should == 1 }
      its(:level) { should == 98 }
      its(:user_id) { should == 31442 }
      its(:finished?) { should be_false }
    end
    describe :last do
      subject { api.all.last }
      its(:id) { should == 5 }
      its(:level) { should == 95 }
      its(:user_id) { should == 69960 }
      its(:finished?) { should be_true }
    end
  end
end
