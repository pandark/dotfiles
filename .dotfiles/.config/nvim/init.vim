set nocompatible
if ! has('nvim') " vim
  set encoding=utf-8
endif
set t_Co=256
set background=dark

" auto-reload .vimrc
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

if has('nvim')
  call plug#begin($HOME.'/.nvim_plugged')
else
  call plug#begin($HOME.'/.vim/plugged')
endif

Plug 'fabi1cazenave/kalahari.vim' " color theme

Plug 'tpope/vim-repeat' " improved `.`
Plug 'tpope/vim-surround' " add surround move
Plug 'tpope/vim-commentary' " (un)comment
Plug 'tpope/vim-unimpaired' " complete pairs
"Plug 'tpope/vim-abolish' " extended replacement patterns
"Plug 'tpope/vim-speeddating' " ^a ^x for dates
"Plug 'tpope/vim-characterize' " more info on ^a
"Plug 'sjl/gundo.vim'

"Plug 'editorconfig/editorconfig-vim'
Plug 'neomake/neomake' " linters
if has('nvim') " neovim
  Plug 'Shougo/deoplete.nvim' " completion
elseif has('vim8') " vim >= 8
  Plug 'maralla/completor.vim' " completion
else " vim < 8
  Plug 'Shougo/neocomplete.vim' " completion
endif

"Plug 'tpope/vim-fugitive' " git
"Plug 'tpope/vim-rhubarb' " github

" status bar
Plug 'vim-airline/vim-airline'
      \ | Plug 'vim-airline/vim-airline-themes'
"Plug 'Yggdroot/indentLine' " display indention levels
Plug 'airblade/vim-gitgutter' " git info in gutter
""Plug 'mhinz/vim-signify' " (or) all cvs info in gutter
Plug 'tomtom/quickfixsigns_vim' " quickfix info in gutter

"Plug 'jmcantrell/vim-virtualenv' " virtualenv
"Plug 'edkolev/tmuxline.vim' " tmux
"Plug 'tpope/vim-eunuch' " unix stuff

"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' " snipets

Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'elzr/vim-json', { 'for': 'json' }
"Plug 'mxw/vim-jsx', { 'for': 'javascript.jsx' }
Plug 'othree/html5.vim', { 'for': 'html' }
""Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
"Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }
Plug 'mustache/vim-mustache-handlebars', { 'for': ['mustache', 'handlebars'] }
"Plug 'digitaltoad/vim-pug', { 'for': 'pug' }
"Plug 'rust-lang/rust.vim', { 'for': 'rust' }
"Plug 'cespare/vim-toml', { 'for': 'toml' }

" Group dependencies, vim-snippets depends on ultisnips
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

Plug 'pandark/42header.vim'

" Add plugins to &runtimepath
call plug#end()

" leader key
let mapleader = ' '

colorscheme kalahari

" status line
set laststatus=2                 " always display the status line
set shortmess=atI                " short messages to avoid scrolling
set title
set ruler                        " show the cursor position all the time
set showcmd                      " display incomplete commands

" autocompletion
set wildmenu                     " show more than one suggestion for completion
set wildmode=list:longest        " shell-like completion (up to ambiguity point)
set wildignore=*.o,*.out,*.obj,*.pyc,.git,.hgignore,.svn,.cvsignore

set autoread                     " watch if the file is modified outside of vim
set hidden                       " allow switching edited buffers without saving

set colorcolumn=80

"set viminfo=%,'50,\"100,:100,n~/.viminfo
set history=100 " keep 100 lines of command line history

set scrolloff=2
set sidescrolloff=5

" search
set incsearch                    " incremental searching
set ignorecase
set smartcase                    " if no caps in patern, not case sensitive

" if the terminal has colors, then syntax highlighting & highlight last research
 if &t_Co > 2 || has("gui_running")
   syntax on
     set hlsearch
     endif

" Put all backup and swap in one place
if has('nvim')
  set backupdir=$HOME/.tmp/nvim,$HOME/.tmp,/tmp
  set directory=$HOME/.tmp/nvim,$HOME/.tmp,/tmp
else
  set backupdir=$HOME/.tmp/vim,$HOME/.tmp,/tmp
  set directory=$HOME/.tmp/vim,$HOME/.tmp,/tmp
endif

if has("vms")
  set nobackup                   " use versions instead of backup file
else
  set backup                     " keep a backup file
endif

" http://tedlogan.com/techblog3.html
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  augroup vimrcEx " {
    au!

    " For all text files set 'textwidth' to 80 characters.
    autocmd FileType text setlocal textwidth=80

    " Jump to the last known cursor position when editing a file
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

    " http://tedlogan.com/techblog3.html
    autocmd FileType sh,zsh,csh,tcsh setlocal ts=4 sts=4 sw=4 et ai " shell
    autocmd FileType c setlocal ts=4 sts=4 sw=4 noet ai " c (42 norm -> noet)
    autocmd FileType make setlocal ts=4 sts=4 sw=4 noet ai " Makefile
    autocmd FileType vim setlocal ts=2 sts=2 sw=2 et ai " Vim
    autocmd FileType text setlocal ts=2 sts=2 sw=2 et ai " Text
    autocmd FileType markdown setlocal ts=4 sts=4 sw=4 et ai " Markdown
    autocmd FileType html* setlocal ts=4 sts=4 sw=4 et ai " (x)HTML
    autocmd FileType php,java setlocal ts=4 sts=4 sw=4 et ai " PHP & Java
    autocmd FileType python setlocal ts=4 sts=4 sw=4 et ai " Python
    autocmd FileType javascript*,json setlocal ts=2 sts=2 sw=2 et ai " JavaScript
    autocmd BufNewFile,BufRead *.h set ft=c " not cpp
    autocmd BufNewFile,BufRead *.mustache,*.hogan,*.hulk,*.hjs set filetype=html.mustache
    autocmd BufNewFile,BufRead *.handlebars,*.hbs set filetype=html.handlebars
    autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    autocmd BufNewFile,BufRead *.webapp set ft=javascript.webapp

  augroup END " }

else
  set autoindent                 " always set autoindent (ai) on
endif " has("autocmd")

set mouse=                       " no mouse

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" inactivate arrows, home and end keys in insert mode
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
inoremap <home> <nop>
inoremap <End> <nop>

set backspace=indent,eol,start   " allow backspacing over everything in insert mode
set formatoptions=cqrt           " comments newline when already in a comment

" scroll more than one line up/down at a time
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

nnoremap <silent> <Leader>/ :nohlsearch<CR>

" Linters
augroup neomake " {
  autocmd! BufWritePost * Neomake
augroup END " }
let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ }
let g:neomake_javascript_enabled_makers = ['eslint', 'jshint']

"nmap <Leader><Space>o :lopen<CR>   " open location window
"nmap <Leader><Space>c :lclose<CR>  " close location window
"nmap <Leader><Space>, :ll<CR>      " go to current error/warning
"nmap <Leader><Space>n :lnext<CR>   " next error/warning
"nmap <Leader><Space>p :lprev<CR>   " previous error/warning

" Surround
"let g:surround_{char2nr('m')} = "{{ \r }}"
"let g:surround_{char2nr('#')} = "{# }\r{/ }"

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Toggle spellcheck and choose the language each time
nmap <silent> <leader>ss :call ToggleSpell()<CR>
function! ToggleSpell() " {
  if &spell == 0 " {
    call inputsave()
    let g:myLang = input('lang: ')
    call inputrestore()
    let &l:spelllang = g:myLang
    setlocal spell
  else
    setlocal nospell
  endif " }
endfunction " }

" 42 header
nmap <f1> :Fortytwoheader<CR>
