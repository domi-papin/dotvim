" needed for pathogen plugin
filetype off
" activate pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

filetype plugin indent on

" no vi comptible mode
set nocompatible

set modelines=0

" indentation and tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

" search 
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

"

" display config
syn on
set number
set showcmd
set scrolloff=3
set showmode
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set wrap
set textwidth=120
set formatoptions=qrn1
" vim 7.3 NEEDED
" set colorcolumn=85
" set relativenumber
" set undofile

set selectmode=mouse
" enable click to edit 
"set mouse=a

" if file was not edited with sudo but write permission is missing 
" will ask for password
cmap w!! %!sudo tee > /dev/null % 

" leader key and mapping 
let mapleader = ","
" invoke ack
nnoremap <leader>a :Ack 
" ,W clear all trailing white spaces
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR> 
" ,v select block of text just pasted
nnoremap <leader>v V`]
" jj alternative to ESC in insert mode
inoremap jj <ESC>
" ,w to split and go the ne w buffer
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>h <C-w>v<C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" F5 to list buffers and switch
:nnoremap <F5> :buffers<CR>:buffer<Space>



