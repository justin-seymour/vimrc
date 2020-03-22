runtime! archlinux.vim
set encoding=UTF-8

if has("syntax")
  syntax on
endif

set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

set number
set rnu "Relative number
set belloff=all
set ts=4 sw=4
set expandtab
set autoindent "Use cindent???
set smartindent

set nocompatible
filetype off

set background=dark

"set viminfo+=n~/.vim/viminfo

"Search down into folders
"Provides tab completion for all file related tasks
set path+=**
" Hit tab to :find partial match
" * makes it fuzzy (eg ':find task*.cpp' finds all tasks in directory)

" ^n does autocomplete in vim

au BufEnter * set fo-=c fo-=r fo-=o

"Vundle stuff (Maybe keep?)
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

"Plugins here

"coc
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

"Papercolor
Plugin 'NLKNguyen/papercolor-theme'

"Vimtex
Plugin 'lervag/vimtex'

"End Vundle stuff
call vundle#end()
filetype plugin indent on

"coc config
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"Colourscheme
"colo ron
colo PaperColor
let &t_ut='' "This fixes weird black line bug

"Turn off the stupid preview window
set completeopt-=preview

"Status bar
set laststatus=2
set statusline=
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ REPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=\ %n\           " buffer number
set statusline+=%#Visual#       " colour
set statusline+=%{&paste?'\ PASTE\ ':''}
set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%#CursorIM#     " colour
set statusline+=%R              " readonly flag/Add h?
set statusline+=%M              "Changes since last save
set statusline+=%#CursorLine#   " colour
set statusline+=\ %t\           " short file name/Use %f instead?
set statusline+=%=              " right align
set statusline+=%#CursorLine#   " colour
set statusline+=\ %Y\           " file type
set statusline+=%#CursorIM#     " colour
set statusline+=\ %3l:%-2c\     " line + column
set statusline+=%#Cursor#       " colour
set statusline+=\ %3p%%\        " percentage

set noshowmode "Turns off showing mode cause it's in status bar

"Fix vim splits
set splitbelow
set splitright

"Vimtex stuff
let g:tex_flavor = 'latex'
let maplocalleader = "\\" "Good enough?? It's convenient at least

hi Normal ctermbg=NONE

let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }

"Auto compile - only works for make and c/c++
function! Runf4()
    if filereadable("./Makefile")
        execute(":w")
        make
    else
        if (&filetype == "c")
            execute(":w")
            execute("exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')")
        elseif (&filetype ==  "cpp")
            execute(":w")
            execute("exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')")
        endif
    endif
endfunction

nmap <F4> :call Runf4()<CR>

