" Created by Justin Seymour
" Stop taking credit for my stuff, Danny

"runtime! archlinux.vim
set encoding=UTF-8

if has("syntax")
    syntax on
endif

set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)
set number
set rnu "Relative number
set belloff=all
set ts=4 sw=4
set expandtab
set autoindent "Use cindent???
set nocompatible
set viminfo+=n~/.vim/viminfo
au BufEnter * set fo-=c fo-=r fo-=o

if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif

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
Plug 'cocopon/iceberg.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

"fzf config
"let g:fzf_layout = { 'down': '40%' }
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'yoffset': 1, 'border': 'none' } }

"coc config
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1):
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
"inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"Turn off the stupid preview window
set completeopt-=preview

set laststatus=2
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

nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Buffers<CR>

hi Normal ctermbg=NONE
set t_Co=256
set background=dark
colo iceberg

"Configure lightline
let g:lightline = {
  \ 'colorscheme': 'codedark',
  \ 'component_function': {
  \     'spelling': 'GetSpell',
  \ }, }

let g:lightline.active = {
  \ 'left': [ [ 'mode', 'paste' ],
  \           [ 'spelling' ],
  \           [ 'readonly', 'filename', 'modified' ] ],
  \ 'right': [ [ 'bufnum' ],
  \            [ 'lineinfo' ],
  \            [ 'percent' ],
  \            [ 'filetype']
  \            ] } 

function! GetSpell()
    return &spell ? 'SPELL' : ''
endfunction

let g:lightline.inactive = {
  \ 'left': [ [ 'filename' ] ],
  \ 'right': [ [ 'bufnum' ],
  \            [ 'lineinfo' ],
  \            [ 'percent' ],
  \            [ 'filetype' ] ] }

let &t_ut='' "This fixes weird black line bug

let g:PaperColor_Theme_Options = {
            \   'theme': {
            \     'default.dark': {
            \       'transparent_background': 1
            \     }
            \   }
            \ }

"Fixes mouse in alacritty
set ttymouse=sgr

"Set language for spell check
set spelllang=en_au

"Functions
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

"Run compiled code - mapping command would probably be easier but oh well
function! Runf4()
    if (&filetype == "c")
        execute("!./%:r")
    elseif (&filetype == "java")
        execute("!java %:r")
    endif
endfunction

"Fairly rudimentary function to comment a line
function! CommentLine()
    execute "normal yypk0d^"
    let line = getline('.')
    execute "normal dd"

    if (&filetype == "c" || &filetype == "cpp" || &filetype == "java")
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
    elseif (&filetype == "vim")
        if (strpart(line, 0, 1) == "\"")
            execute "normal ^x"
        else
            execute "normal ^i\""
        endif
    endif
endfunction

"Bind functions
nmap <F4> :call Runf4()<CR>
nmap <F3> :call Runf3()<CR>
nnoremap <leader>; :call CommentLine()<CR>

