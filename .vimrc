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
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.hg,.svn
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

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
 
" if file was not edited with sudo but write permission is missing 
" will ask for password
cmap w!! %!sudo tee > /dev/null % 

" leader key and mapping 
let mapleader = ","
" invoke ack
let g:ackprg="ack-grep -H --nocolor --nogroup"
nnoremap <leader>a :Ack 
" ,W clear all trailing white spaces
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR> 
" ,s replace word under cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
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
" F6 to switch paste mode
set pastetoggle=<F6>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" close current buffer and preserve split windows 
" Mormal mode : <Leader> c ou d (save&&close or close only)
map <Leader>c <Esc>:call CleanClose(1) <CR>
map <Leader>d <Esc>:call CleanClose(0) <CR>

function! CleanClose(tosave)
    if (a:tosave == 1)
        w!
    endif
    let todelbufNr = bufnr("%")
    let newbufNr = bufnr("#")
    if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
        exe "b".newbufNr
    else
        bnext
    endif

    if (bufnr("%") == todelbufNr)
        new
    endif
    exe "bd".todelbufNr
endfunction


"statusline setup
set statusline=%0f "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
set statusline+=%y "filetype
set statusline+=%r "read only flag
set statusline+=%m "modified flag

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file
set laststatus=2

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

" Plugins configuration 
"

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']
" map <Leader>n :NERDTreeToggle<CR>

" Command-T configuration
let g:CommandTMaxHeight=20

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
" uncomment to silent warnings : let g:syntastic_quiet_warnings=1
let g:syntastic_auto_loc_list=2

" Remember last location in file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
