" $HOME/.vimrc
"   Created at 2010.10.04
"   Revised at 2011.04.11

"--------------------------------------------------
" 基本設定 Basic
"--------------------------------------------------
set nocompatible        " vi非互換
let mapleader=","       " キーマップリーダー
set scrolloff=5         " スクロール時の余白確保
set textwidth=0         " 1行に長い文章を書いていても自動折り返しをしない
set nobackup            " バックアップを取らない
set autoread            " 他で書き換えられたら自動で読みなおす
set noswapfile          " スワップファイルを作らない
set hidden              " 編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start   " バックスペースで何でも消せるように
set formatoptions=lmoq  " テキスト整形オプション、マルチバイト系を追加
set vb t_vb=            " ビープを鳴らさない
set browsedir=buffer    " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]   " カーソルの行頭、行末で止まらないようにする
set showcmd             " コマンドをステータス行に表示
set showmode            " 現在のモードを表示
set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
set modelines=0         " モードラインは無効

" OSのクリップボードを使用する
" set clipboard+=unnamed   Yank/Pasteができなくなったので、コメントアウト
" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

" ヤンクした文字はシステムのクリップボードに入れる
" set clipboard=unnamed   Yank/Pasteができなくなったので、コメントアウト
" 挿入モードでCtrl+kを押すとクリップボードの内容を貼り付けられるようにする
imap <C-K> <ESC>"*pa

" Ev/Rvでvimrcの編集と反映
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC

" pathogenでftdetectなどをloadさせるために、一度ファイルタイプ判定をoff
filetype off
" pathogen.vimによってbundle配下のpluginをpathに加える
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
set helpfile=$VIMRUNTIME/doc/help.txt
" ファイルタイプ判定をon
filetype plugin on

" --------------------------------------------------
"  ステータスライン StausLine
" --------------------------------------------------
set laststatus=2    " 常にステータスラインを表示

" カーソルが何行目の何列目に置かれているかを表示
set ruler

" ステータスラインに文字コードと改行文字を表示する
if winwidth(0) >= 120
    set statusline=[%n%{bufnr('$')>1?'/'.bufnr('$'):''}%{winnr('$')>1?':'.winnr().'/'.winnr('$'):''}]%<%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
    set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
    autocmd!
    autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
    autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

function! GetB()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    let c = iconv(c, &enc, &fenc)
    return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
    let n = a:nr
    let r = ""
    while n
        let r = '0123456789ABCDEF'[n % 16] . r
        let n = n / 16
    endwhile
    return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
    let out = ''
    let ix = 0
    while ix < strlen(a:str)
        let out = out . Nr2Hex(char2nr(a:str[ix]))
        let ix = ix + 1
    endwhile
    return out
endfunc

" --------------------------------------------------
" 表示 Apperance
" --------------------------------------------------
set showmatch     " 括弧の対応をハイライト
set number        " 行番号表示
set list          " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:<    " 不可視文字の表示形式
set display=uhex  " 印字不可能文字を16進数で表示
set title         " 編集中のファイル名を表示

highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" カーソル行をハイライト
set cursorline
" カレントウィンドウのみ罫線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=white guibg=white

" コマンド実行中は再描画しない
set lazyredraw
" 高速ターミナル接続を行う
set ttyfast

" --------------------------------------------------
"  インデント Indent
" --------------------------------------------------
set autoindent       " 自動でインデント
"set paste           " ペースト時にautoindentを無効に(onにすると、
"autocomplpop.vimが動かない)
set smartindent      " 新しい行を開始したときに、新しい行のインデントを現在行と同じにする
set cindent          " Cプログラムファイルの自動インデントを始める
" softtabstopはTabキー押し下げ時の挿入される空白の量, 0の場合はtabstopと同じ,
" BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0

if has("autocmd")
  " ファイルタイプの検索を有効にする
  filetype plugin on
  " そのファイルタイプに合わせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  autocmd FileType html :set indentexpr=
  autocmd FileType xhtml :set indentexpr=
endif

" --------------------------------------------------
"  補完・履歴 Complete
" --------------------------------------------------
set wildmenu              " コマンド補完を強化
set wildchar=<tab>        " コマンド補完を開始するキー
set wildmode=list:full    " リスト表示、最長マッチ
set history=1000          " コマンド・検索パターンの履歴数
set complete+=k           " 補完に辞書ファイルを追加

"<c-space>でomni補完
" imap <c-space> <c-x><c-o>

" --tabでオムニ補完
function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col -1] !~ '\k\|<\|/'
    return "\<tab>"
  elseif exists('&omnifunc') && &omnifunc == ''
    return "\<c-n>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" --------------------------------------------------
"  タグ関連 Tags
" --------------------------------------------------
" set tags
if has("autochdir")
  " 編集しているファイルのディレクトリに自動で移動
  set autochdir
  set tags=tags;
else
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif

"<C-t>はscreenとかぶるので削除
"tab pagesを使い易くする
" nnoremap <C-t>  <Nop>
" nnoremap <C-t>n  ;<C-u>tabnew<CR>
" nnoremap <C-t>c  ;<C-u>tabclose<CR>
" nnoremap <C-t>o  ;<C-u>tabonly<CR>
" nnoremap <C-t>j  ;<C-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
" nnoremap <C-t>k  gT

"tags-and-searchesを使い易くする
nnoremap t  <Nop>
"「飛ぶ」
nnoremap tt  <C-]>
"「進む」
nnoremap tj  ;<C-u>tag<CR>
"「戻る」
nnoremap tk  ;<C-u>pop<CR>
"履歴一覧
nnoremap tl  ;<C-u>tags<CR>

" --------------------------------------------------
"  検索設定 Search
" --------------------------------------------------
set wrapscan     " 最後まで検索したら、先頭へ戻る
set ignorecase   " 大文字小文字無視
set smartcase    " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch    " インクリメンタルサーチ
set hlsearch     " 検索文字をハイライト
"Escの2回押しでハイライト消去
nmap <Esc><Esc> ;nohlsearch<CR><Esc>

"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
""選択した文字列を置換
vnoremap /r "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'

"Ctrl-iでヘルプ
nnoremap <C-i> :<C-u>help<Space>
"カーソル下のキーワードをヘルプで引く
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><Enter>

":Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>
"カーソル下の単語をGrepBufferする
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>

" --------------------------------------------------
"  移動設定 Move
" --------------------------------------------------
" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up>   gk

" 0, 9で行頭、行末へ
nmap 1 0
nmap 9 $

" insert modeでの移動
imap <C-e> <END>
imap <C-a> <HOME>

"<space>j, <space>kで画面送り
nnoremap <Space>j <C-f>
nnoremap <Space>k <C-b>

"spaceで次のbufferへ。back-spaceで前のbufferへ。
nmap <Space> ;MBEbn<CR>
nmap <BS> ;MBEbp<CR>

" F2で前のバッファ
map <F2> <ESC>;bp<CR>
" F3で次のバッファ
map <F3> <ESC>;bn<CR>
" F4でバッファを削除する
map <F4> <ESC>;bw<CR>

" フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 最後に編集された位置に移動
nnoremap gb '[
nnoremap gp ']

" 対応する括弧に移動
nnoremap [ %
nnoremap ] %

" 最後に変更されたテキストを選択する
nnoremap gc `[v`]a
vnoremap gc ;<C-u>normal gc<Enter>
onoremap gc ;<C-u>normal gc<Enter>

" カーソルの位置の単語をyankする
nnoremap vy vawy

" 矩形選択で自由に移動する
set virtualedit+=block

" ビジュアルモード時vで行まで選択
vnoremap v $h

" CTRL-hjklでウィンドウ移動
nnoremap <C-j> ;<C-w>j
nnoremap <C-k> ;<C-k>j
nnoremap <C-l> ;<C-l>j
nnoremap <C-h> ;<C-h>j

" --------------------------------------------------
"  エンコーディング関連 Encoding
" --------------------------------------------------
set ffs=unix,dos,mac   " 改行文字
set encoding=utf-8     " デフォルトエンコーディング

" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" cvsの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp
" 以下のファイルの時は文字コードをutf-8に設定
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType python :set fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

" --------------------------------------------------
"  カラー関連 Colors
" --------------------------------------------------
" ターミナルタイプによるカラー設定
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86" || &term =~ "xterm-256color"
  set t_Co=16
  set t_Sf=^[[3%dm
  set t_Sb=^[[4%dm
elseif &term =~ "xterm-color"
  set t_Co=8
  set t_Sf=^[[3%dm
  set t_Sb=^[[4%dm
endif
"
" ハイライト on
syntax enable
"
" 補完候補の色付け for vim7
hi Pmenu ctermbg=white ctermfg=darkgray
hi PmenuSel ctermbg=blue ctermfg=white
hi PmenuSbar ctermbg=0 ctermfg=9
"
" --------------------------------------------------
"  編集関連 Edit
" --------------------------------------------------
" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
"
" yeでそのカーソル位置にある単語をレジスタに追加
nmap ye :let @"=expand("<cword>")<CR>
" Visualモードでのpで選択範囲をレジスタの内容に置き換える
vnoremap p <Esc>;let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>
"
" Tabキーを空白に変換
set expandtab
"
" コンマの後に自動的にスペースを挿入
" inoremap , ,<Space>
" XMLの閉じタグを自動挿入
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END
"
" Insert mode中で単語単位/行単位の削除をUndo可能にする
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
"
" :Ptでインデントモード切り替え
command! Pt :set paste!
"
" y9で行末までヤンク
nmap y9 y$
" y0で行頭までヤンク
nmap y0 y^
"
" 括弧を自動保存
" inoremap { {}<LEFT>
" inoremap [ []<LEFT>
" inoremap ( ()<LEFT>
" inoremap " ""<LEFT>
" inoremap ' ''<LEFT>
" vnoremap { "zdi^V{<C-R>z}<ESC>
" vnoremap [ "zdi^V[<C-R>z]<ESC>
" vnoremap ( "zdi^V(<C-R>z)<ESC>
" vnoremap " "zdi^V"<C-R>z^V"<ESC>
" vnoremap ' "zdi'<C-R>z'<ESC>
"
" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換する
" autocmd BufWritePre * :%s/\t/ /ge

" 日時の自動入力
inoremap <expr> ,df strftime('%Y/%m/%d %H:%M:%S')
inoremap <expr> ,dd strftime('%Y/%m/%d')
inoremap <expr> ,dt strftime('%H:%M:%S')

" --------------------------------------------------
"  その他 Misc
" --------------------------------------------------
" C-;がEscape
inoremap jj <Esc>
cnoremap jj <Esc>
"
" ;でコマンド入力(;と:を入れ替え)
nnoremap ; :
nnoremap : ;

" --------------------------------------------------
"  プラグインごとの設定 Plugins
" --------------------------------------------------
"
" --------------------------------------------------
"  MiniBufExplorer
" --------------------------------------------------
" set minibfexp
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize = 10

" :TmでMiniBufExplorerの表示トグル
command! Mt :TMiniBufExplorer

" --------------------------------------------------
"  NERD_commneter.vim
" --------------------------------------------------
" コメントの間にスペースを空ける
let NERDSpaceDelims = 1
" <Leader>xでコメントをトグル
map <Leader>x  <Leader>c<space>
" 未対応ファイルタイプのエラーメッセージを表示しない

" --------------------------------------------------
"  grep.vim
" --------------------------------------------------
" 検索外のディレクトリ・ファイルパターン
let Grep_Skip_Dirs = '.svn .git .hg'
let Grep_Skip_Files = '*.bak *~'

" --------------------------------------------------
"  vimshell
" --------------------------------------------------
let g:vimshell_user_prompt = 'fnamemodify(getcwd(),  ":~")'
let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]",  "(%s)-[%b|%a]")'
let g:vimshell_enable_smart_case = 1

if has('win32') || has('win64')
  " Display user name on Windows.
  let g:vimshell_prompt = $USERNAME."% "
else
  " Display user name on Linux.
  let g:vimshell_prompt = $USER."% "

  call vimshell#set_execute_file('bmp, jpg, png, gif',  'gexe eog')
  call vimshell#set_execute_file('mp3, m4a, ogg',  'gexe amarok')
  let g:vimshell_execute_file_list['zip'] = 'zipinfo'
  call vimshell#set_execute_file('tgz, gz',  'gzcat')
  call vimshell#set_execute_file('tbz, bz2',  'bzcat')
endif

function! g:my_chpwd(args,  context)
  call vimshell#execute('echo "chpwd"')
endfunction
function! g:my_emptycmd(cmdline,  context)
  call vimshell#execute('echo "emptycmd"')
  return a:cmdline
endfunction
function! g:my_preprompt(args,  context)
  call vimshell#execute('echo "preprompt"')
endfunction
function! g:my_preexec(cmdline,  context)
  call vimshell#execute('echo "preexec"')
  if a:cmdline =~# '^\s*diff\>'
    call vimshell#set_syntax('diff')
  endif
  return a:cmdline
endfunction

autocmd FileType vimshell
\ call vimshell#altercmd#define('g',  'git')
\| call vimshell#altercmd#define('i',  'iexe')
\| call vimshell#altercmd#define('l',  'll')
\| call vimshell#altercmd#define('ll',  'ls -l')
\| call vimshell#hook#set('chpwd',  ['g:my_chpwd'])
\| call vimshell#hook#set('emptycmd',  ['g:my_emptycmd'])
\| call vimshell#hook#set('preprompt',  ['g:my_preprompt'])
\| call vimshell#hook#set('preexec',  ['g:my_preexec'])

command! Vs :VimShell

"------------------------------------
" neocomplecache.vim
"------------------------------------
" " AutoComplPopを無効にする
" let g:acp_enableAtStartup = 0
" NeoComplCacheを有効にする
let g:neocomplcache_enable_at_startup = 1
" smarrt case有効化。 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplcache_enable_smart_case = 1
" camle caseを有効化。大文字を区切りとしたワイルドカードのように振る舞う
let g:neocomplcache_enable_camel_case_completion = 1
" _(アンダーバー)区切りの補完を有効化
let g:neocomplcache_enable_underbar_completion = 1
" シンタックスをキャッシュするときの最小文字長を3に
let g:neocomplcache_min_syntax_length = 3
" neocomplcacheを自動的にロックするバッファ名のパターン
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" -入力による候補番号の表示
let g:neocomplcache_enable_quick_match = 1
" 補完候補の一番先頭を選択状態にする(AutoComplPopと似た動作)
let g:neocomplcache_enable_auto_select = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scala' : $HOME.'/.vim/bundle/vim-scala/dict/scala.dict',
    \ 'java' : $HOME.'/.vim/dict/java.dict',
    \ 'c' : $HOME.'/.vim/dict/c.dict',
    \ 'cpp' : $HOME.'/.vim/dict/cpp.dict',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'ocaml' : $HOME.'/.vim/dict/ocaml.dict',
    \ 'perl' : $HOME.'/.vim/dict/perl.dict',
    \ 'php' : $HOME.'/.vim/dict/php.dict',
    \ 'scheme' : $HOME.'/.vim/dict/scheme.dict',
    \ 'vm' : $HOME.'/.vim/dict/vim.dict'
    \ }

" Define keyword.
" if !exists('g:neocomplcache_keyword_patterns')
    " let g:neocomplcache_keyword_patterns = {}
" endif
" let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" ユーザー定義スニペット保存ディレクトリ
let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'

" スニペット
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)

" 補完を選択しpopupを閉じる
inoremap <expr><C-y> neocomplcache#close_popup()
" 補完をキャンセルしpopupを閉じる
inoremap <expr><C-e> neocomplcache#cancel_popup()
" TABで補完できるようにする
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" undo
inoremap <expr><C-g>     neocomplcache#undo_completion()
" 補完候補の共通部分までを補完する
inoremap <expr><C-l> neocomplcache#complete_common_string()
" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" C-kを押すと行末まで削除
inoremap <C-k> <C-o>D
" C-nでneocomplcache補完
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" C-pでkeyword補完
inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 補完候補が出ていたら確定、なければ改行
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>,  <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-x><C-o> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()

" FileType毎のOmni補完を設定
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType ruby set omnifunc=rubycomplete#Complete

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'

" --------------------------------------------------
"  surround.vim
" --------------------------------------------------
" s, ssで選択範囲を指定文字でくくる
nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround

" --------------------------------------------------
"  unite.vim
" --------------------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> <Leader>ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> <Leader>um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> <Leader>uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> <Leader>ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

" --------------------------------------------------
"  ChangeLog
" --------------------------------------------------
let g:changelog_timeformat="%c"
let g:changelog_username="Tomokatsu Mizukusa <mizukusa.tomokatsu@gmail.com>"

"" ファイルを開いた際に、前回終了時の行で起動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
