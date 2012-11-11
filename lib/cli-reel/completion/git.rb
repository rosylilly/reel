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

        SUBOPTIONS = {
          'add' => [
            '-n', '-v', '--force', '-f', '--interactive', '-i', '--patch', '-p',
            '--edit', '-e', '--all', '--update', '-u', '--intent-to-add', '-N',
            '--refresh', '--ignore-errors', '--ignore-missing'
          ],
          'am' => [
            '--signoff', '--keep', '--keep-cr', '--no-keep-cr', '--utf8', '--no-utf8',
            '--3way', '--interactive', '--committer-date-is-author-date',
            '--ignore-date', '--ignore-space-change', '--ignore-whitespace',
            '--whitespace=', '-C', '-p', '--directory=<dir>', '--exclude=<path>',
            '--include=<path>', '--reject', '-q', '--quiet', '--scissors', '--no-scissors'
          ],
          'archive' => [
            '--format=', '--list', '--prefix=<dir>', '-o', '--output=<path>',
            '--worktree-sttributes', '--remote=', '--exec='
          ],
          'status' => [
            '-s', '--short', '-b', '--branch', '--porcelain', '-u', '--untracked-files',
            '--ignore-submodules', '--ignored', '-z', '--column', '--no-column'
          ]
        }

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

        def resolve_command(command)
          return command unless @subcommands.include?(command)

          dic = Hash[*@aliases.flatten]
          return command unless dic.keys.include?(command)

          dic[command].sub(/ .*/, '')
        end

        def complement(args, word)
          commands = args.dup.delete_if{|arg|
            arg.match(/^-/) || (args.last == arg && word == arg)
          }

          case commands.length
          when 0
            if word.match(/^-/)
              options(OPTIONS, word)
            else
              subcommands(word)
            end
          when 1 .. Float::INFINITY
            command = resolve_command(commands.first)

            if self.respond_to?(:"comp_#{command}")
              self.send(:"comp_#{command}", args, word)
            else
              if word.match(/^-/)
                options(SUBOPTIONS[command], word)
              else
                ls(word)
              end
            end
          end
        end
      end
    end
  end
end
