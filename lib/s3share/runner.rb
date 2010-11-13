module S3Share
  class Runner
    def initialize(*args)
      @args = Args.new(args)
      @filename = args.first

      # Print usage instructions if the filename is empty.
      if @filename.nil?
        puts "usage: s3.rb [filename]"
        exit(-1)
      end

      @path = get_full_path
      @filename = clean_filename

      # Upload the file, save the URL and return it to
      # `#set_clipboard_url` so we can save it in the user's
      # clipboard before exiting.
      exit_code = set_clipboard_url(upload_file)
      exit(exit_code)
    end

    # Returns the full path for @filename.
    def get_full_path
      if !@filename.include?("/") # single file name
        "#{Dir.pwd}"
      elsif @filename[0,1] == "/" # absolute path
        "#{@filename.split("/")[0..-2].join("/")}"
      else                        # relative path
        "#{Dir.pwd}/#{@filename.split("/")[0..-2].join("/")}"
      end
    end

    # returns the filename (without the path).
    def clean_filename
      @filename = @filename.split("/").last
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

      AWS::S3::S3Object.store(@filename, open("#{@path}/#{@filename}"),
                              bucket_name,
                              :access => :public_read)

      url = "http://s3.amazonaws.com/#{bucket_name}/#{@filename}"
      puts "\n #{@filename} uploaded to: #{url}\n\n"
    end

    # Saves `url` in the clipboard for easy access.
    def set_clipboard_url(url)
      system "echo #{url} | #{clipboard_cmd}"
    end

    # Returns the name of the command that allows you to pipe stuff
    # into the clipboard. `pbcopy` for OS X, no idea what it is in
    # other systems.
    def clipboard_cmd
      "pbcopy"
    end

    # Finds an error by name and prints it (without exiting).
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
  end
end
