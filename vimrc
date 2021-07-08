" Created by Justin Seymour
" Stop taking credit for my stuff Danny

"runtime! archlinux.vim
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
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

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

set viminfo+=n~/.vim/viminfo

" Fix indenting
au BufEnter * set fo-=c fo-=r fo-=o

"Plugin stuff
"Auto install plugins
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source /etc/vimrc
endif

call plug#begin('~/.vim/plugged')

"Plugins here
Plug 'justin-seymour/vim-code-dark'
Plug 'NLKNguyen/papercolor-theme'
Plug 'ajmwagar/vim-deus'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()
"filetype plugin indent on

"coc config
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"Colourscheme
"colo PaperColor
colo codedark
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
let mapleader = "\<Space>"

"Remap for easier window + buffer navigation
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>l :wincmd l<CR>

nnoremap <leader>= :resize +2<CR>
nnoremap <leader>- :resize -2<CR>
nnoremap <leader>. :vertical resize +5<CR>
nnoremap <leader>, :vertical resize -5<CR>

nnoremap <leader>n :bnext <CR>
nnoremap <leader>p :bprev <CR>
"Just do <C-w>= for equal
"<C-w>_ maxes split
"<C-w>| maxes v split

nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Buffers<CR>

hi Normal ctermbg=NONE

let g:PaperColor_Theme_Options = {
            \   'theme': {
            \     'default.dark': {
            \       'transparent_background': 1
            \     }
            \   }
            \ }

" Fixes mouse in alacritty
set ttymouse=sgr

"Set language for spell check
set spelllang=en_au

" Functions
"Compile - only works for make and c/c++
function! Runf3()
    if filereadable("./Makefile")
        execute(":w")
        make
    else
        if (&filetype == "c")
            execute(":w")
            execute("exec '!gcc '.shellescape('%').' -o '.shellescape('%:r')")
        elseif (&filetype ==  "cpp")
            execute(":w")
            execute("exec '!g++ '.shellescape('%').' -o '.shellescape('%:r')")
        endif
    endif
endfunction

" Run compiled code - mapping command would probably be easier but oh well
function! Runf4()
    execute("! ./%:r")
endfunction

" Fairly rudimentary function to comment a line
function! CommentLine()

    "duplicate line and delete whitespace
    execute "normal yypk0d^"

    "put into variable
    let line = getline('.')

    "delete line
    execute "normal dd"

    "if commented - uncomment
    "else comment

    if (&filetype == "c" || &filetype == "cpp")
        if (strpart(line, 0, 2) == "//")
            execute "normal ^xx"
        else
            execute "normal ^i/\/\<ESC>"
        endif
    elseif (&filetype == "tex")
        if (strpart(line, 0, 1) == "%")
            execute "normal ^x"
        else
            execute "normal ^i%"
        endif
    endif

endfunction

" Bind functions
nmap <F4> :call Runf4()<CR>
nmap <F3> :call Runf3()<CR>
nnoremap <leader>; :call CommentLine()<CR>

