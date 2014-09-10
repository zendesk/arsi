require 'helper'

describe Arsi::BasicInspector do

  it "should require arguements" do
    assert_raises(ArgumentError) do
      Arsi::BasicInspector.new
    end
  end

  describe '#check?' do
    it "should match basic strings" do
      inspector = Arsi::BasicInspector.new("drop table")
      assert inspector.check?("drop table all_our_base");
      refute inspector.check?("create table all_our_base")
    end

    it "should match regexps" do
      inspector = Arsi::BasicInspector.new(/drop table/)
      assert inspector.check?("drop table all_our_base");
      refute inspector.check?("create table all_our_base")
    end

    it "should use procs" do
      inspector = Arsi::BasicInspector.new {|sql| sql =~ /drop table/}
      assert inspector.check?("drop table all_our_base");
      refute inspector.check?("create table all_our_base")
    end
  end
end
