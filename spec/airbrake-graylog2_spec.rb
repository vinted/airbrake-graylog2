# encoding: utf-8

require 'spec_helper'

describe Airbrake do

  context "configuration" do
    it "should have default configuration values" do
      subject.configuration.host.should                 == 'localhost'
      subject.configuration.port.should                 == 12201
      subject.configuration.graylog2_level.should       == GELF::Levels::ERROR
      subject.configuration.graylog2_facility.should    == 'airbrake_graylog2'
      subject.configuration.graylog2_max_size.should    == 'WAN'
      subject.configuration.graylog2_extra_args.should  == {}
    end

    it "should allow configuring" do
      subject.configure do |config|
        config.graylog2_facility = "test-notifier"
        config.graylog2_level = GELF::Levels::WARN
      end

      subject.configuration.graylog2_facility.should == "test-notifier"
      subject.configuration.graylog2_level.should    == GELF::Levels::WARN
    end
  end

  context "sending exception" do

    it "should send notification to Graylog2" do
      subject.notify(Exception.new("Test exception"))
    end

  end

end
