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

      module Util
        def q(string)
          Regexp.quote string
        end

        def subcommands(word)
          (@subcommands || []).grep(/^#{Regexp.quote word}/)
        end

        def options(options, word)
          comps = options.grep(/^#{Regexp.quote word.sub(/=.*/, '')}/)

          comp = (comps[0] || '').sub(/<\w+>/, '')
          if comps.size == 1 && word.match(/^#{q comp}/) && comps[0].match(/=<(\w+)>$/)
            pattern = $1.to_s
            path = word.sub(/^#{q comp}/, '')
            case pattern
            when 'path'
              ls(path)
            when 'dir'
              dirs(path)
            when 'file'
              files(path)
            else
              comp
            end
          else
            comps.map do |comp|
              comp.sub(/<\w+>/, '')
            end
          end
        end

        def ls(word)
          Readline::FILENAME_COMPLETION_PROC.call(word)
        end

        def dirs(word)
          (ls(word) || []).select do |path|
            FileTest::directory?(path)
          end
        end

        def files(word)
          (ls(word) || []).select do |path|
            FileTest::file?(path)
          end
        end
      end
    end
  end
end

Dir[File.expand_path('../completion/*.rb', __FILE__)].each do |file|
  require file
end
