$LOAD_PATH.unshift 'lib'
require 's3share/version'

Gem::Specification.new do |s|
  s.name              = "s3share"
  s.version           = S3Share::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Upload your files to S3 and share them with your friends."
  s.homepage          = "http://github.com/febuiles/s3share"
  s.email             = "federico.builes@gmail.com"
  s.authors           = [ "Federico Builes" ]
  s.has_rdoc          = false

  s.files             = %w( README.markdown Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")

  s.add_development_dependency "rspec", "pamela"
  s.add_dependency "aws-s3"

  s.executables       = %w( s3.rb )
  s.description       = <<desc
S3Share allows simple uploads to Amazon S3 from your command line. Set
your access ENV variables (see website) and upload the file:

    $ s3.rb kezia.png

      kezia.png uploaded to: http://s3.amazonaws.com/heroin-uploads/kezia.png

desc
end
