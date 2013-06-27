" $HOME/.vimrc
"   Created at 2010.10.04
"   Revised at 2013.02.05

" --------------------------------------------------
" Basicな設定 {{{
" --------------------------------------------------
set nocompatible       " vi非互換
let mapleader=","       " キーマップリーダー
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_darwin = has('mac') || has('macunix') || has('gui_macvim')
let s:is_unix = !s:is_windows && !s:is_cygwin && !s:is_darwin

if s:is_windows
  " use english interface
  language message en
  "exchange path separator
  set shellslash
else
  " use english interface
  language message C
endif
" }}}

" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

" --------------------------------------------------
" Neobundle.vimの設定 {{{
" --------------------------------------------------
filetype off
let s:config_root = expand('~/.vim')
let s:bundle_root = expand('~/bundle')
let s:neobundle_root = s:bundle_root . "/neobundle.vim"

if has('vim_starting')
  if s:is_windows
    set runtimepath+=~/vimfiles/neobundle.vim
  else
    execute "set runtimepath+=" . s:neobundle_root
  endif
  call neobundle#rc(s:bundle_root)
endif
" }}}

" --------------------------------------------------
" 自動でリポジトリと同期するプラグイン {{{
" --------------------------------------------------
" NeoBundle自身に管理
NeoBundleFetch 'Shougo/neobundle.vim'

" vimprocにより、非同期プロセスを可能に
NeoBundle "Shougo/vimproc.vim", {
  \ "build": {
  \   "windows" : "make -f make_mingw32.mak",
  \   "cygwin"  : "make -f make_cygwin.mak",
  \   "mac"     : "make -f make_mac.mak",
  \   "unix"    : "make -f make_unix.mak",
  \ }}

" Recognize charcode automatically
NeoBundle "banyan/recognize_charcode.vim"

" Style / Display {{{
NeoBundle "vim-scripts/desert256.vim"
NeoBundle "jnurmine/Zenburn"
NeoBundle "tomasr/molokai"
NeoBundle "nanotech/jellybeans.vim"

"NeoBundle "Lokaltog/vim-powerline"
"let s:hooks = neobundle#get_hooks("vim-powerline")
"function! s:hooks.on_source(bundle)
"  let g:Powerline_symbols = 'fancy'
"endfunction

NeoBundle "jceb/vim-hier"
NeoBundle "vim-scripts/restore_view.vim"

"NeoBundle "nathanaelkane/vim-indent-guides"
"let s:hooks = neobundle#get_hooks("vim-indent-guides")
"function! s:hooks.on_source(bundle)
"  let g:indent_guides_guide_size = 1
"  nnoremap <silent> [toggle]i :IndentGuidesToggle<CR>
"  IndentGuidesEnable
"endfunction

NeoBundleLazy "vim-scripts/ShowMarks", {
  \ "autoload": {
  \   "commands": ["ShowMarksPlaceMark", "ShowMarksToggle"],
  \ }}
nnoremap [showmarks] <Nop>
nmap M [showmarks]
nnoremap [showmarks]m :ShowMarksPlaceMark<CR>
nnoremap [showmarks]t :ShowMarksToggle<CR>
let s:hooks = neobundle#get_hooks("ShowMarks")
function! s:hooks.on_source(bundle)
  let showmarks_text = '>>'
  let showmarks_textupper = '>>'
  let showmarks_textother = '>>'
  let showmarks_hlline_lower = 0
  let showmarks_hlline_upper = 1
  let showmarks_hlline_other = 0
  " ignore ShowMarks on buffer type of
  " Help, Non-modifiable, Preview, Quickfix
  let showmarks_ignore_type = 'hmpq'
endfunction
" }}}

" Syntax / Indent / Omni {{{
" syntax /indent /filetypes for git
NeoBundleLazy 'tpope/vim-git', {'autoload': { 'filetypes': 'git' }}
NeoBundleLazy 'groenewege/vim-less.git', {'autoload': { 'filetypes': 'less' }}
NeoBundleLazy 'mizutomo/mast.git', {'autoload': { 'filetypes': 'mast' }}
NeoBundleLazy 'vim-scripts/spectre.vim', {'autoload': { 'filetypes': 'spectre' }}
NeoBundleLazy 'http://sip1.mu.renesas.com/git/misc/verilog_systemverilog.git', {
      \ 'autoload': { 'filetypes': 'verilog_systemverilog'}}
" }}}
"
" File Management {{{
NeoBundle "thinca/vim-template"
autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
  silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
  silent! %s/<+FILENAME+>/\=expand('%:r')/g
endfunction
autocmd MyAutoCmd User plugin-template-loaded
  \ if search('<+CURSOR+>')
  \ | silent! execute 'normal! "_da>'
  \ | endif
" }}}

" Unite {{{
NeoBundleLazy "Shougo/unite.vim", {
  \ "autoload": {
  \   "commands": ["Unite", "UniteWithBufferDir"]
  \ }}
NeoBundleLazy 'h1mesuke/unite-outline', {
  \ "autoload": {
  \   "unite_sources": ["outline"],
  \ }}
nnoremap [unite] <Nop>
nmap U [unite]
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]r :<C-u>Unite register<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]w :<C-u>Unite window<CR>
let s:hooks = neobundle#get_hooks("unite.vim")
function! s:hooks.on_source(bundle)
  " start unite in insert mode
  let g:unite_enable_start_insert = 1
  " use vimfiler to open directory
  call unite#custom_default_action("source/bookmark/directory", "vimfiler")
  call unite#custom_default_action("directory", "vimfiler")
  call unite#custom_default_action("directory_mru", "vimfiler")
  autocmd MyAutoCmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    imap <buffer> <Esc><Esc> <Plug>(unite_exit)
    nmap <buffer> <Esc> <Plug>(unite_exit)
    nmap <buffer> <C-n> <Plug>(unite_select_next_line)
    nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
  endfunction
endfunction
" }}} Unite

" VimFiler {{{
NeoBundleLazy "Shougo/vimfiler", {
  \ "depends": ["Shougo/unite.vim"],
  \ "autoload": {
  \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
  \   "mappings": ['<Plug>(vimfiler_switch)'],
  \   "explorer": 1,
  \ }}
nnoremap <Leader>e :VimFilerExplorer<CR>
" close vimfiler automatically when there are only vimfiler open
autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
let s:hooks = neobundle#get_hooks("vimfiler")
function! s:hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1

  " vimfiler specific key mappings
  autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
  function! s:vimfiler_settings()
    " ^^ to go up
    nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
    " use R to refresh
    nmap <buffer> R <Plug>(vimfiler_redraw_screen)
    " overwrite C-l
    nmap <buffer> <C-l> <C-w>l
  endfunction
endfunction
let g:vimfiler_as_default_explorer = 1  " Vimfilerをデフォルトのファイラにする。
" ディレクトリで開いた場合にVimFilerを起動
if isdirectory(expand("%:p"))
  autocmd VimEnter * VimFiler
endif
" VimFiler }}}

" Git {{{
NeoBundleLazy "mattn/gist-vim", {
  \ "depends": ["mattn/webapi-vim"],
  \ "autoload": {
  \   "commands": ["Gist"],
  \ }}

" vim-fugitive use `autocmd` a Lost so cannot be Loaded with Lazy
NeoBundle "tpope/vim-fugitive"
"NeoBundleLazy "tpope/vim-fugitive", {
"  \ "autoload": {
"  \   "command": [
"  \     "Gstatus", "Gwrite", "Gread", "Gmove",
"  \     "Gremove", "Gcommit", "Gblame", "Gdiff",
"  \     "Gbrowse",
"  \ ]}}
nnoremap <Leader>gd :<C-u>Gdiff<Enter>
nnoremap <Leader>gs :<C-u>Gstatus<Enter>
nnoremap <Leader>gl :<C-u>Glog<Enter>
nnoremap <Leader>ga :<C-u>Gwrite<Enter>
nnoremap <Leader>gc :<C-u>Gcommit<Enter>
nnoremap <Leader>gC :<C-u>Git commit --amend<Enter>
nnoremap <Leader>gb :<C-u>Gblame<Enter>
NeoBundleLazy "gregsexton/gitv", {
  \ "depends": ["tpope/vim-fugitive"],
  \ "autoload": {
  \   "commands": ["Gitv"],
  \ }}
" Git }}}

" Editing support {{{
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/Align'
NeoBundle 'vim-scripts/YankRing.vim'
" }}}

" NeoComplete/NeoCompleCache {{{
if has('lua') && v:version > 703 && has('patch885')
  NeoBundleLazy "Shougo/neocomplete.vim", {
    \ "autoload": {
    \   "insert": 1,
    \ }}
  let s:hooks = neobundle#get_hooks("neocomplete.vim")
  function! s:hooks.on_source(bundle)
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    "NeoCompleteEnable
    let g:neocomplete#enable_at_startup = 1
  endfunction
else
  NeoBundleLazy "Shougo/neocomplcache.vim", {
    \ "autoload": {
    \   "insert": 1,
    \ }}
  let s:hooks = neobundle#get_hooks("neocomplcache.vim")
  function! s:hooks.on_source(bundle)
    let g:acp_enableAtStartup = 0
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_min_syntax_length = 3
    "NeoComplCacheEnable
    let g:neocomplcache_enable_at_startup = 1

    autocmd MyAutoCmd FileType neocomplcache call s:neocomplcache_settings()
    function! s:neocomplcache_settings()
      " 補完を選択しpopupを閉じる
      inoremap <expr><C-y> neocomplcache#close_popup()
      " 補完をキャンセルしpopupを閉じる
      inoremap <expr><C-e> neocomplcache#cancel_popup()
      " TABで補完できるようにする
      inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
      " undo
      inoremap <expr><C-g> neocomplcache#undo_completion()
      " 補完候補の共通部分までを補完する
      inoremap <expr><C-l> neocomplcache#complete_common_string()
      " SuperTab like snippets behavior.
      imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable()
            \ ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
      " C-kを押すと行末まで削除
      "inoremap <C-k> <C-o>D
      " C-nでneocomplcache補完
      inoremap <expr><C-n> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
      " C-pでkeyword補完
      inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
      " 補完候補が出ていたら確定、なければ改行
      inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"

      " <TAB>: completion.
      inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
      " <C-h>,  <BS>: close popup and delete backword char.
      inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
      inoremap <expr><C-x><C-o> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()
    endfunction
  endfunction
endif
" NeoComplete/NeoCompleCache }}}

" NeoSnippet {{{
NeoBundleLazy "Shougo/neosnippet.vim", {
  \ "depends": ["honza/vim-snippets"],
  \ "autoload": {
  \   "insert": 1,
  \ }}
let s:hooks = neobundle#get_hooks("neosnippet.vim")
function! s:hooks.on_source(bundle)
  " Plugin key-mappings
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k> <Plug>(neosnippet_expand_target)
  " SuperTab like snippets behaviour
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"
  " For snippet_complete marker
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif
  " Enable snipMate compatibility feature
  let g:neosnippet#enable_snipmate_compatibility = 1
  " Tell Neosnippet about the other snippets
  let g:neosnippet#snippets_directory=s:bundle_root . '/vim-snippets/snippets'
endfunction
" NeoSnippet }}}

" Gundo/TaskList {{{
NeoBundleLazy "sjl/gundo.vim", {
  \ "autoload": {
  \   "commands": ['GundoToggle'],
  \}}
nnoremap <Leader>g :GundoToggle<CR>

NeoBundleLazy "vim-scripts/TaskList.vim", {
  \ "autoload": {
  \   "mappings": ['<Plug>TaskList'],
  \}}
nmap <Leader>T <plug>TaskList
" Gundo/TaskList }}}

" Programming {{{
" vim-quickrun {{{
NeoBundleLazy "thinca/vim-quickrun", {
  \ "autoload": {
  \   "mappings": [['nxo', '<Plug>(quickrun)']]
  \ }}
nmap <Leader>r <Plug>(quickrun)
let s:hooks = neobundle#get_hooks("vim-quickrun")
function! s:hooks.on_source(bundle)
  let g:quickrun_config = {
    \ "*": {"runmode": "async:remote:vimproc"}
    \ }
  " Syntax Check
  let g:quickrun_config['syntax/mast'] = {
        \ 'runner': 'vimproc',
        \ 'command': 'mast',
        \ 'cmdopt': '-c',
        \ 'exec': '%c %o %s:p',
        \}
  autocmd MyAutoCmd BufWritePost *.sin QuickRun -outputer quickfix -type syntax/mast
endfunction
" vim-quickrun }}}

NeoBundleLazy 'majutsushi/tagbar', {
  \ "autload": {
  \   "commands": ["TagbarToggle"],
  \ },
  \ "build": {
  \   "mac": "brew install ctags",
  \ }}
nmap <Leader>t :TagbarToggle<CR>

NeoBundle "scrooloose/syntastic", {
  \ "build": {
  \   "mac": ["pip install pyflake", "npm -g install coffeelint"],
  \   "unix": ["pip install pyflake", "npm -g install coffeelint"],
  \ }}

" Python {{{
NeoBundleLazy "lambdalisue/vim-django-support", {
  \ "autoload": {
  \   "filetypes": ["python", "python3", "djangohtml"]
  \ }}
NeoBundleLazy "jmcantrell/vim-virtualenv", {
  \ "autoload": {
  \   "filetypes": ["python", "python3", "djangohtml"]
  \ }}
NeoBundleLazy "davidhalter/jedi-vim", {
  \ "autoload": {
  \   "filetypes": ["python", "python3", "djangohtml"],
  \   "build": {
  \     "mac": "pip install jedi",
  \     "unix": "pip install jedi",
  \   }
  \ }}
let s:hooks = neobundle#get_hooks("jedi-vim")
function! s:hooks.on_source(bundle)
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#popup_select_first = 0
  let g:jedi#show_function_definition = 1
  let g:jedi#rename_command = '<Leader>R'
  let g:jedi#goto_command = '<Leader>G'
endfunction
NeoBundleLazy "nvie/vim-flake8", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"],
      \   "build": {
      \     "mac" : "pip install flake8",
      \     "unix": "pip install flake8",
      \   }
      \ }}
let s:hooks = neobundle#get_hooks("vim-flake8")
function! s:hooks.on_source(bundle)
  let g:flake8_ignore = 'E111,E401'
endfunction
" Python }}}

" Programming }}}

" Pandoc {{{
NeoBundleLazy "vim-pandoc/vim-pandoc", {
  \ "autoload": {
  \   "filetypes": ["text", "pandoc", "markdown", "rst", "textile"],
  \ }}
NeoBundleLazy "lambdalisue/shareboard.vim", {
  \ "autoload": {
  \   "commands": ["ShareboardPreview", "ShareboardCompile"],
  \ },
  \ "build": {
  \   "mac": "pip install shareboard",
  \   "unix": "pip install shareboard",
  \ }}
function! s:shareboard_settings()
  nnoremap <buffer>[shareboard] <Nop>
  nmap <buffer><Leader> [shareboard]
  nnoremap <buffer><silent> [shareboard]v :ShareboardPreview<CR>
  nnoremap <buffer><silent> [shareboard]c :ShareboardCompile<CR>
endfunction
autocmd MyAutoCmd FileType rst,text,pandoc,markdown,textile call s:shareboard_settings()
let s:hooks = neobundle#get_hooks("shareboard.vim")
function! s:hooks.on_source(bundle)
  let g:shareboard_command = expand('~/.vim/shareboard/command.sh markdown+autolink_bare_uris+abbreviations')
  " add ~/.cabal/bin to PATH
  let $PATH=expand("~/.cabal/bin:") . $PATH
endfunction
" Pandoc }}}

" Ramdisk {{{
function! s:ramdisk_settings()
  if s:is_windows
    let l:ramdisk_prefix = 'R:\'
  elseif s:is_darwin
    " http://sourceforge.jp/projects/rom/
    let l:ramdisk_prefix = '/Volumes/RamDisk/'
  elseif s:is_unix
    " mount -t tmpfs -o size=128m tmpfs /mnt/ramdisk
    let l:ramdisk_prefix = '/mnt/ramdisk'
  else
    let l:ramdisk_prefix = ''
  endif
  " use ramdisk only when the directory exists
  if l:ramdisk_prefix && isdirectory(l:ramdisk_prefix)
    let g:neocomplete_temporary_dir = l:ramdisk_prefix . '.neocon'
    let g:neocomplcache_temporary_dir = l:ramdisk_prefix . '.neocon'
    let g:vimfiler_data_directory = l:ramdisk_prefix . '.vimfiler'
    let g:unite_data_directory = l:ramdisk_prefix . '.unite'
    let g:ref_cache_dir = l:ramdisk_prefix . '.vim_ref_cache'
  endif
endfunction
call s:ramdisk_settings()
" Ramdisk }}}

" VimShell {{{
NeoBundleLazy 'Shougo/vimshell.git', {
      \ "autoload": {
      \   "commands": ["VimShell"],
      \ }}
" ,is: シェルを起動
nnoremap <silent> <Leader>is :VimShell<CR>
" ,ipy: pythonを非同期で起動
nnoremap <silent> <Leader>ipy :VimShellInteractive python3<CR>
" ,ss: 非同期で開いたインタプリタに現在の行を評価させる
vmap <silent> <Leader>ss: VimShellSendString
" }}}

NeoBundle 'houtsnip/vim-emacscommandline'             " Vim-EmacsCommandLine
NeoBundle 'sakuraiyuta/commentout.vim'
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'http://sip1.mu.renesas.com/git/misc/verilog_systemverilog.git'
" Plugin }}}

" Install missing plugins
NeoBundleCheck

unlet s:hooks

filetype plugin indent on

" --------------------------------------------------
" 基本設定 Basic {{{
" --------------------------------------------------
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
set modeline            " モードラインを有効に
"set modelines=0         " モードラインは無効
set helplang=ja,en     " ヘルプの検索を 日本語->英語 に

" OSのクリップボードを使用する
if has('unnamedplus')
  set clipboard& clipboard+=unnamedplus
else
  set clipboard& clipboard+=unnamed
endif

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

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" Jump to matching pairs easily with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" toggle
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :<C-u>setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :<C-u>setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :<C-u>setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :<C-u>setl wrap!<CR>:setl wrap?<CR>
" 基本設定 Basic }}}

" --------------------------------------------------
" ステータスライン StausLine {{{
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
"  ステータスライン StausLine }}}

" --------------------------------------------------
" 表示 Apperance {{{
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
"set cursorline
" カレントウィンドウのみ罫線を引く
"augroup cch
"  autocmd! cch
"  autocmd WinLeave * set nocursorline
"  autocmd WinEnter,BufRead * set cursorline
"augroup END

" コマンド実行中は再描画しない
set lazyredraw
" 高速ターミナル接続を行う
set ttyfast
" 表示 Apperance }}}

" --------------------------------------------------
"  インデント Indent {{{
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
"  インデント Indent }}}

" --------------------------------------------------
"  補完・履歴 Complete {{{
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
"  補完・履歴 Complete }}}

" --------------------------------------------------
"  タグ関連 Tags {{{
" --------------------------------------------------
" set tags
if has("autochdir")
  " 編集しているファイルのディレクトリに自動で移動
  set autochdir
  set tags=tags;
else
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif

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
"  タグ関連 Tags }}}

" --------------------------------------------------
"  検索設定 Search {{{
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
"  検索設定 Search }}}

" --------------------------------------------------
"  移動設定 Move {{{
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

" bsでバッファ表示
nnoremap bb :ls<CR>:buf
" 移動設定 Move }}}

" --------------------------------------------------
" エンコーディング関連 Encoding {{{
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
" エンコーディング関連 Encoding }}}

" --------------------------------------------------
"  カラー関連 Colors {{{
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
"  カラー関連 Colors }}}

" --------------------------------------------------
"  編集関連 Edit {{{
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
"inoremap <expr> <Leader>df strftime('%Y/%m/%d %H:%M:%S')
"inoremap <expr> <Leader>dd strftime('%Y/%m/%d')
"inoremap <expr> <Leader>dt strftime('%H:%M:%S')
"  編集関連 Edit }}}

" --------------------------------------------------
"  その他 Misc {{{
" --------------------------------------------------
" C-;がEscape
inoremap jj <Esc>
cnoremap jj <Esc>
"
" ;でコマンド入力(;と:を入れ替え)
nnoremap ; :
nnoremap : ;

" その他 Misc }}}
"
" --------------------------------------------------
"  surround.vim
" --------------------------------------------------
" s, ssで選択範囲を指定文字でくくる
nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround

" --------------------------------------------------
"  ChangeLog
" --------------------------------------------------
let g:changelog_timeformat="%c"
let g:changelog_username="Tomokatsu Mizukusa <mizukusa.tomokatsu@gmail.com>"

"" ファイルを開いた際に、前回終了時の行で起動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"" 拡張子とファイルタイプの関連付け
autocmd BufNewFIle,BufRead *.scs set filetype=spectre
autocmd BufNewFIle,BufRead *.sin set filetype=mast
autocmd BufNewFIle,BufRead *.sv set filetype=verilog_systemverilog
