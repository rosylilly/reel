# Cli::Reel

[repl](https://github.com/defunkt/repl) みたいに特定コマンドの repl を提供する CLI アプリケーションです。

repl との違いは

- 色がつく
- 強力な補完が書ける

くらいしかありません。repl の補完が弱すぎて気に食わないから作った。

デフォルトで補完をサポートしているコマンドは

- git(wip)

## Installation

    $ gem install cli-reel

## Usage

git の reel

    $ reel git
    REEL: git
    (git)>> status
    # On branch master
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    # modified:   README.md
    #
    no changes added to commit (use "git add" and/or "git commit -a")
    (git)>>

オプションつけて実行も出来る

    $ reel git status
    REEL: git status
    (git)>>
    # On branch master
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    # modified:   README.md
    #
    no changes added to commit (use "git add" and/or "git commit -a")
    (git)>>

`--version` などのオプションをつけるときは少し違う

    $ reel -- ruby -v
    REEL: ruby -v
    (ruby)>>
    ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-darwin11.4.0]

## Options

- -v / --[no-]verbose
- -d / --[no-]debug
- -H / --[no-]histroy
- -c / --[no-]color
- -r MOD / --require=MOD

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
