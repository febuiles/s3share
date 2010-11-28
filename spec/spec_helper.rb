$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rspec'
require 's3share'

# Silences any stream for the duration of the block.
#
#   silence_stream(STDOUT) do
#     puts 'This will never be seen'
#   end
#
#   puts 'But this will'
def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen('/dev/null')
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
end