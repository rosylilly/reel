require 'cli-reel/version'
require 'cli-reel/runner'

module Cli
  module Reel
    def self.start(argv)
      Runner.new(argv).start
    end
  end
end
