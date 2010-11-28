require 'spec_helper'

describe S3Share::Runner do

  def runner(filename)
    S3Share::Runner.new(filename)
  end

  let(:relative)      { runner("something/spec.opts") }
  let(:absolute)      { runner("/Users/someone/something/spec.opts") }
  let(:file)          { runner("spec.opts") }
  let(:existing_file) { runner(__FILE__) }

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
  
  describe "#upload_file" do
    it "checks if the bucket exists before starting the upload" do
      # Stub this method so we don't try a real upload.
      AWS::S3::S3Object.stub!(:store).and_return(nil) 
      
      ENV["AMAZON_S3_DEFAULT_BUCKET"] = "an_imaginary_bucket"
      existing_file.should_receive(:create_bucket_if_it_does_not_exist).with("an_imaginary_bucket").and_return(:nil)
      silence_stream(STDOUT) { existing_file.upload_file }
    end
  end
  
  describe "#create_bucket_if_it_does_not_exist" do
    it "calls AWS::S3::Bucket.find to see if the bucket exists" do
      AWS::S3::Bucket.should_receive(:find).with("the_bucket").and_return(nil)
      existing_file.send :create_bucket_if_it_does_not_exist, "the_bucket"
    end
    
    it "calls AWS::S3::Bucket.create if the bucket doesn't exist" do
      AWS::S3::Base.establish_connection!(:access_key_id => ENV["AMAZON_ACCESS_KEY_ID"], :secret_access_key => ENV["AMAZON_SECRET_ACCESS_KEY"])
      AWS::S3::Bucket.should_receive(:create).with("an_imaginary_bucket_that_surely_does_not_exist").and_return(nil)
      silence_stream(STDOUT) do
        existing_file.send :create_bucket_if_it_does_not_exist, "an_imaginary_bucket_that_surely_does_not_exist"
      end
    end
  end
end

