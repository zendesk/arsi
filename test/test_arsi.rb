require 'helper'

describe Arsi do
  before do
  end

  describe "#defaults" do
    it "raises errors on invalid configuration" do
      assert_raises(ArgumentError) do
        Arsi.con
      end
    end
  end



end