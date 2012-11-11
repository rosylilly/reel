module Cli
  module Reel
    class Completion
      def self.get(command)
        if self.const_defined?(command.upcase)
          return self.const_get(command.upcase).new
        end

        new(command)
      end

      def initialize(command)
        @command = command
      end

      def complement(args)
        Readline::FILENAME_COMPLETION_PROC.call(args.last || '')
      end
    end
  end
end

Dir[File.expand_path('../completion/*.rb', __FILE__)].each do |file|
  require file
end
