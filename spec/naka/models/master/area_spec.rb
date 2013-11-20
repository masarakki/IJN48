require 'spec_helper'

describe Naka::Models::Master::Area do
  let(:area) { mock_user.api.master.area }

  describe :type do
    describe :normal do
      [1, 2, 3, 4, 5].each do |area_id|
        context :id, area_id do
          it { expect(area.find(area_id)).not_to be_event_area }
        end
      end
      [23, 24].each do |area_id|
        context :id, area_id  do
          it { expect(area.find(area_id)).to be_event_area }
        end
      end
    end
  end
end
