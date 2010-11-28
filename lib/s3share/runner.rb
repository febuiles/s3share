module S3Share
  class Runner
    def initialize(*args)
      @args = Args.new(args)
      @filename = args.first
    end

    # Starts the execution.
    def run
      if @filename.nil?
        puts "usage: s3.rb [filename]"
        exit(-1)
      end

      @path = get_directory
      @filename = clean_filename

      # Upload the file and save the URL in the clipboard
      exit_code = set_clipboard_url(upload_file)
      exit(exit_code)
    end

    # The user can specify absolute paths, relative paths and individual
    # filenames so we need to make sure we return the proper path to the
    # directory.
    def get_directory
      if !@filename.include?("/") # single file name
        "#{Dir.pwd}"
      elsif @filename[0,1] == "/" # absolute path
        "#{@filename.split("/")[0..-2].join("/")}"
      else                        # relative path
        "#{Dir.pwd}/#{@filename.split("/")[0..-2].join("/")}"
      end
    end

    # Returns only the filename, discarding any directory info.
    def clean_filename
      @filename.split("/").last
    end


    # Uploads the file to Amazon S3 and returns the URL for the
    # object. Uploaded files are publicly readable.
    def upload_file
      bucket_name = ENV["AMAZON_S3_DEFAULT_BUCKET"] || ""
      access_key = ENV["AMAZON_ACCESS_KEY_ID"] || ""
      secret_key = ENV["AMAZON_SECRET_ACCESS_KEY"] || ""

      if bucket_name.empty?
        print_error(:no_default_bucket)
        exit(-2)
      end

      if access_key.empty? || secret_key.empty?
        print_error(:wrong_aws_credentials)
        exit(-3)
      end

      AWS::S3::Base.establish_connection!(
        :access_key_id     => access_key,
        :secret_access_key => secret_key
      )
      
      create_bucket_if_it_does_not_exist(bucket_name)

      AWS::S3::S3Object.store(@filename, open("#{@path}/#{@filename}"),
                              bucket_name,
                              :access => :public_read)

      url = "http://s3.amazonaws.com/#{bucket_name}/#{@filename}"
      puts "\n #{@filename} uploaded to: #{url}\n\n"
      url
    end

    # Saves `url` in the clipboard for easy access. `#clipboard_cmd`
    # should be extended for other platforms (right now only OS X is
    # supported).
    def set_clipboard_url(url)
      system "echo #{url} | #{clipboard_cmd}"
    end

    # Returns the name of the command that allows you to pipe stuff
    # into the clipboard. `pbcopy` for OS X, no idea what it is in
    # other systems.
    def clipboard_cmd
      "pbcopy"
    end

    # Finds an error by name and prints the associated error string.
    def print_error(err)
      errors = {
        :no_default_bucket =>
        ["\nENV variable AMAZON_S3_DEFAULT_BUCKET has not been set.",
         "Please run:",
         "     export AMAZON_S3_DEFAULT_BUCKET=\"bucket-name\"",
         "\nRead the documentation for more information.\n\n"],
        :wrong_aws_credentials =>
        ["\nAWS credentials are invalid. Make sure that you have set the ENV:",
         "\n     export AMAZON_ACCESS_KEY_ID=\"your-access-key\"",
         "     export AMAZON_SECRET_ACCESS_KEY=\"your-secret-key\"",
         "\nRead the documentation for more information.\n\n"]
      }
      errors[err].each { |msg| puts msg }
    end
    
    private
    # Check if the bucket exists and create it if it doesn't.
    def create_bucket_if_it_does_not_exist(bucket_name)
      AWS::S3::Bucket.find(bucket_name)
    rescue AWS::S3::NoSuchBucket => e
      puts "Bucket '#{bucket_name}' does not exist. Creating it..."
      AWS::S3::Bucket.create(bucket_name)
    end
  end
end
