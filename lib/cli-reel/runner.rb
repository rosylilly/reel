require 'optparse'
require 'rainbow'
require 'readline'
require 'cli-reel/completion'

module Cli
  module Reel
    class Runner
      def initialize(argv)
        @argv = argv
        @debug = false
        @verbose = false
        @history = true
        Sickill::Rainbow.enabled = false
        load_configs
        opt_parse(@argv)
      end

      def opt_parse(argv)
        OptionParser.new.tap { |opt|
          opt.banner = "Usage: reel [options] command ..."
          opt.version = Cli::Reel::VERSION

          opt.on('-d', '--[no-]debug', 'debug mode') {|v| self.debug = v }
          opt.on('-v', '--[no-]verbose', 'verbose') {|v| self.verbose = v }
          opt.on('-H', '--[no-]history', 'histroy') {|v| self.history = v }
          opt.on('-c', '--[no-]color', 'color') {|v| Sickill::Rainbow.enabled = !!v }
          opt.on('-r MODULE', '--require=MODULE') {|mod| require mod }
        }.parse!(argv)
      end

      def debug=(bool)
        @debug = !!bool
      end

      def verbose=(bool)
        @verbose = !!bool
      end

      def history=(bool)
        @history = !!bool
      end

      def load_configs
        ["#{ENV['HOME']}/.reel", ".reel"].each do |file|
          load_config(file)
        end
      end

      def load_config(file)
        return unless File.exist?(file)
        content = File.read(file)
        args = content.split(/\s|\r\n|\r|\n/)
        opt_parse(args)
      end

      def start
        return opt_parse(['--help']) if @argv.empty?

        @command = @argv.shift
        @preset_args = @argv
        puts "REEL: #{prefix.color(:green)}"

        repl
      end

      def prefix
        "#{@command} #{@preset_args.join(' ')}"
      end

      def repl
        instance = self
        Readline.completion_proc = proc { |word|
          instance.completion_proc(word)
        }

        while buffer = Readline.readline("(#{@command.color(:green)})>> ", @history)
          run(buffer)
        end
      end

      def run(input)
        eval_string = "#{prefix} #{input}"
        puts "<< #{eval_string.color(:red)}" if @verbose || @debug
        system(eval_string)
      end

      def completion_proc(word)
        Readline.completion_append_character = ''
        words = @preset_args + Readline.line_buffer.split(/ |\t|\n/)
        completion.complement(words, word)
      end

      def completion
        @completion ||= Completion.get(@command)
      end
    end
  end
end
