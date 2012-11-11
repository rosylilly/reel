module Cli
  module Reel
    class Completion
      class GIT
        include Util

        MAIN_PORCELAIN_COMMANDS = [
          'add', 'am', 'archive', 'bisect', 'branch',
          'bundle', 'checkout', 'cherry-pick', 'citool',
          'clean', 'clone', 'commit', 'describe', 'diff',
          'fetch', 'format-patch', 'gc', 'grep', 'gui',
          'init', 'log', 'merge', 'mv', 'notes', 'pull', 'push',
          'rebase', 'reset', 'revert', 'rm', 'shortlog', 'show',
          'stash', 'status', 'submodule', 'tag'
        ].freeze

        ANCILLARY_COMMANDS = [
          'config', 'fast-export', 'fast-import', 'filter-branch',
          'lost-found', 'mergetool', 'pack-refs', 'prune', 'reflog',
          'relink', 'remote', 'replace', 'repo-config', 'annotate',
          'blame', 'cherry', 'count-objects', 'difftook', 'fsck',
          'get-tar-commit-id', 'help', 'instaweb', 'merge-tree',
          'rerere', 'rev-parse', 'show-branch', 'verify-tag',
          'whatchanged'
        ].freeze

        INTERACTING_WITH_OTHERS_COMMANDS = [
          'archimport', 'csvexportcommit', 'csvimport',
          'csvserver', 'imap-send', 'p4', 'quiltimport',
          'request-pull', 'send-email', 'svn'
        ].freeze

        OPTIONS = [
          '--version',
          '--help',
          '-c',
          '--exec-path=<path>',
          '--html-path',
          '--man-path',
          '--info-path',
          '-p', '--paginate',
          '--no-pager',
          '--git-dir=<dir>',
          '--work-tree=<dir>',
          '--namespace=',
          '--bare',
          '--no-replace-objects'
        ]

        def initialize
          @subcommands =
            MAIN_PORCELAIN_COMMANDS +
            ANCILLARY_COMMANDS +
            INTERACTING_WITH_OTHERS_COMMANDS
          @aliases = []
          resolve_aliases
        end

        def resolve_aliases
          (`git config --get-regexp "alias\."`).split(/\r\n|\n|\r/).each do |line|
            matched = line.match(/\Aalias\.(\w+) (.+)$/)
            @aliases << [matched[1], matched[2]]
            @subcommands << matched[1]
          end
        end

        def complement(args)
          commands = args.dup.delete_if{|arg| arg.match(/^-/) || args.last == arg }
          word = args.last || ''

          case commands.length
          when 0
            if word.match(/^-/)
              options(OPTIONS, word)
            else
              subcommands(word)
            end
          when 1 .. Float::INFINITY
          end
        end
      end
    end
  end
end
