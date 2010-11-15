require 'spec_helper'

describe S3Share::Runner do

  def runner(filename)
    S3Share::Runner.new(filename)
  end

  let(:relative) { runner("something/spec.opts") }
  let(:absolute) { runner("/Users/someone/something/spec.opts") }
  let(:file)     { runner("spec.opts") }

  describe "#get_directory" do
    it "correctly expands a relative path" do
      relative.get_directory.should == Dir.pwd + "/something"
    end

    it "returns absolute paths without the filename" do
      absolute.get_directory.should == "/Users/someone/something"
    end

    it "finds the directory for a given filename" do
      file.get_directory.should == Dir.pwd
    end
  end

  describe "#clean_filename" do
    it "returns the correct filename for a relative path" do
      relative.clean_filename.should == "spec.opts"
    end

    it "returns the correct filename for a absolute path" do
      absolute.clean_filename.should == "spec.opts"
    end

    it "returns the correct filename for a file path" do
      file.clean_filename.should == "spec.opts"
    end
  end
end

