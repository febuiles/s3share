#!/usr/bin/env ruby -rubygems

require "s3share"
S3Share::Runner.new(*ARGV).run
