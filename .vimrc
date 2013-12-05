" .vimrc

set nocompatible                 " Vim is better than Vi
set encoding=utf-8               " utf8 or gtfo

" Visual settings
set t_Co=256                     " force vim to use 256 colors
set background=dark

let mapleader = ' '        " leader key used by some plugins
"let g:mapleader = ' '     " gvim leader key used by some plugins

" auto-reload .vimrc
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Pathogen plugin management
call pathogen#infect()
"call pathogen#helptags()        " Generate doc for all plugins

" theme
colorscheme kalahari

filetype plugin indent on        " activate filetype detection,

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

" break long lines visually (not actual lines)
set wrap linebreak
set tw=0 wm=0

"set autowrite                   " Auto-save before :next, :make, etc.

" Highlighting spaces and tabulations
" (\zs & \ze == start and end of match, \s == any space)
match ErrorMsg '\s\+$'           " Match trailing whitespace
match ErrorMsg '\ \+\t'          " & spaces before a tab
match ErrorMsg '[^\t]\zs\t\+'    " & tabs not at the begining of a line
match ErrorMsg '\[^\s\]\zs\ \{2,\}' " & 2+ spaces not at the begining of a line

if exists('+colorcolumn')
  set colorcolumn=80
"else
"  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

set textwidth=0
"set whichwrap=<,>,h,l
"map <C-UP> g k
"map <C-UP> g k
set viminfo=%,'50,\"100,:100,n~/.viminfo
set history=100                  " keep 100 lines of command line history

set scrolloff=2
set sidescrolloff=5

" search
set incsearch                    " incremental searching
set smartcase                    " if no caps in patern, not case sensitive
" if the terminal has colors
" switch syntax highlighting on
" & highlight last research
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Put all backup and swap in one place
set backupdir=~/.vim/tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim/tmp,~/.tmp,~/tmp,/var/tmp,/tmp

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
  autocmd FileType sh setlocal ts=4 sts=4 sw=4 et ai " sh
  autocmd FileType c setlocal ts=4 sts=4 sw=4 noet ai " c
  autocmd FileType make setlocal ts=4 sts=4 sw=4 noet ai " Makefile
  autocmd FileType vim setlocal ts=2 sts=2 sw=2 et ai " Vim
  autocmd FileType text setlocal ts=2 sts=2 sw=2 et ai " Text
  autocmd FileType markdown setlocal ts=4 sts=4 sw=4 et ai " Markdown
  autocmd FileType html setlocal ts=4 sts=4 sw=4 et ai " (x)HTML
  autocmd FileType php,java setlocal ts=4 sts=4 sw=4 et ai " PHP & Java
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2 et ai nocindent " JavaScript
  autocmd BufNewFile,BufRead *.h set ft=c
  autocmd BufNewFile,BufRead *.json set ft=javascript
  autocmd BufNewFile,BufRead *.webapp set ft=javascript

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
inoremap <Up> <nop>

set backspace=indent,eol,start   " allow backspacing over everything in insert mode
set formatoptions=cqrt           " comments newline when already in a comment

" scroll more than one line up/down at a time
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

nnoremap <silent> <Leader>/ :nohlsearch<CR>

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

