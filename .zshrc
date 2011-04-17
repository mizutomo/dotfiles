## cdコマンドのサーチパス
#cdpath=(.. ~ ~/src ~/zsh)

## デフォルトパーミッションの設定
## 新規ファイルは644, 新規ディレクトリは755
umask 022

## エイリアス定義
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias git='nocorrect git'
alias make='nocorrect make'
alias j=jobs
alias h=history
alias grep=egrep
alias ls='gls -F --color=yes'
alias ll='ls -l'
alias la='ls -a'
alias clean='rm *~'
alias telaset='ssh -i ~/.ssh/id_rsa.asad02 -l t.mizukusa asad02'
alias gcc-4.3='gcc-mp-4.3'
alias g++-4.3='g++-mp-4.3'
alias gcc='gcc -Wall'
alias g++='g++ -Wall'
alias ruby='ruby -w'
alias ruby1.9='ruby1.9 -w'
alias ssh='ssh -l t.mizukusa'
alias diff='diff -u'
alias cdz='nocorrect cd /Users/mizutomo/Work/ASET/02_Development/Zantho'
alias vi='/usr/bin/vim'
alias screen='screen -t main'
alias make='make -j 4'
alias makelog='make -j 1 |& tee make.log'

## ディレクトリとディレクトリのシンボリックリンクのみを表示するエイリアス
alias lsd='ls -ld *(-/DN)'

## "."で始まるファイルのみを表示するエイリアス
alias lsa='ls -ld .*'

## グローバルエイリアスの設定
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'
alias -g G='|grep'
alias -g GI='|grep -i'

## gitとsvnの互換
funtion git() { if [ -d .svn ]; then command svn $*; else command git $*; fi }

## csh風のsetenvを関数で定義
setenv () { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }

## autoloadされる関数を検索するパス
fpath=($fpath ~/.zfunc)

## 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

## プロンプトの設定
PROMPT='%n%# '
RPROMPT=' %~'

## manマニュアルに配置されているディレクトリパス
manpath=($X11HOME/man /usr/man /usr/lang/man /usr/local/man /opt/local/man)
export MANPATH

## EDITOR
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

## その他の環境変数の定義
HISTSIZE=2000
SAVEHIST=100000
HISTFILE=~/.zhistory
DIRSTACKSIZE=100

## 
## zshオプションの設定(_の有無/大文字、小文字は無視)
##
## ヒストリ関連
setopt histnostore        # historyコマンドをヒストリに記録しない
setopt histignoredups     # 重複コマンドをヒストリに記録しない
setopt histreduceblanks   # 余分なスペースを削除して、ヒストリに記録
setopt incappendhistory   # 複数のzshを横断的にコマンドを実行した順にヒストリを記録
setopt sharehistory       # 複数のzshセッションでヒストリをリアルタイムに共有
## ファイルグロブ
setopt extendedglob       # 拡張ファイルグロブを使用
setopt globdots           # .で始まるファイルにもマッチさせる
#setopt numericglobsort    # ファイルなどを数値順にソートして表示
## 入出力
setopt noclobber          # リダイレクト時にファイルを上書きしようとするとエラーを表示
setopt correct            # コマンド名のスペル訂正を試みる
setopt correctall         # 引数についてもスペル訂正を試みる
setopt ignore_eof         # Ctrl-Dでログアウトしない
## ディレクトリ変更
setopt cdable_vars        # 絶対パスが入った変数をディレクトリとみなす
setopt auto_cd            # ディレクトリ名を入力するだけで移動
setopt auto_pushd         # cdコマンドだけで、ディレクトリスタックにpushdする
setopt pushdminus
setopt pushdtohome
## ジョブ制御
setopt autoresume         # ジョブの頭文字1文字だけでジョブの再実行を行う
setopt longlistjobs       # ジョブリストにロングフォーマットを使用する
setopt notify             # バックグラウンドジョブの状態を即座に表示
setopt recexact
## 補完
setopt autolist           # 補完候補が複数ある時、自動でメニューをリストアップする
setopt listpacked         # 補完候補を詰めて表示
setopt listtypes          # 補完候補を表示する際に、ファイルの種類も表示

## zshモジュールのロード
zmodload -a zsh/stat stat          # statコマンド
zmodload -a zsh/zpty zpty          
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

## キーバインドはemacsモード
bindkey -e

## キーバインドはviモード
#bindkey -v

## 補完機能を有効にする
autoload -U compinit
compinit

## プロンプトに色をつける
autoload -U colors
colors

## GNUPLOTの出力先
export GNUTERM=x11

## Intel TBB (Threading Building Block)
export TBB21_INSTALL_DIR=/opt/local/tbb
source $TBB21_INSTALL_DIR/ia32/cc4.0.1_os10.4.9/bin/tbbvars.sh

## CUDAの設定
export PATH=/usr/local/cuda/bin:$PATH
export CPLUS_INCLUDE_PATH="/Developer/GPU Computing/C/common/inc":/usr/local/cuda/include:$CPLUS_INCLUDE_PATH
export C_INCLUDE_PATH="/Developer/GPU Computing/C/common/inc":/usr/local/cuda/include:$C_INCLUDE_PATH
export LIBRARY_PATH="/Developer/GPU Computing/C/common/lib":"/Developer/GPU Computing/C/lib":/usr/local/lib:$LIBRARY_PATH
export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib:$LD_LIBRARY_PATH

## Latex Pathの追加
export PATH=/Applications/pTeX.app/teTeX/bin:$PATH
export PATH=/usr/local/texlive/2010/bin/universal-darwin:$PATH

## Emacsの設定
export PATH=/Applications/Emacs.app/Contents/MacOS/bin:$PATH
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs -r'
alias ec='emacsclient'

## Emacsからシェルを利用するときの設定
[[ $EMACS = t ]] && unsetopt zle
[[ $TERM = "eterm-color" ]] && TERM=xterm-color

## Python Scripting for Computational Science
export scripting=$HOME/Program/NumPython
export PATH=/Library/Frameworks/Python.framework/Versions/2.6/bin:$PATH
