" https://github.com/amix/vimrc

""""""""""""""
""""" Settings
""""""""""""""

" set encoding to utf-8
set encoding=utf-8
" minimal number of lines to always keep visible above the cursor when scrolling
set scrolloff=7
" set history size
set history=500
" use 4 spaces when pressing tab and use auto-/smart indenting
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
" use spaces instead of tabs
set expandtab
" show number in current line and relative number in all others
set number relativenumber
" block: Ctrl+v marks whole block (even across EOL) / all (extends block mode): cursor may be additionally placed after EOL
set virtualedit=block
" when turned on, show \n, \t and space
set listchars=eol:$,tab:>-,space:·
" allow a new buffer to be created when current one has not been saved yet
set hidden
" autocompletion
set wildmenu
set wildmode=list:longest,full
" Search down into subfolders. Provides tab-completion for all file-related tasks.
set path+=**
" highlight search results and use search behaviour as in modern browsers
set hlsearch
set incsearch
" Use global directory for swap files
set directory^=/tmp//
" Enable modelines in files
set modeline
" Always show current filename in status
set statusline=%F%m%r%<\ %=%l/%L\ [%p%%],\ Row\ %v
highlight statusline ctermbg=white ctermfg=black
set laststatus=2
" Use a more visible color when highlighting matching parens
highlight MatchParen ctermbg=blue
" Split more naturally
set splitbelow
set splitright

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view

""""""""""""""""""
""""" Key mappings
""""""""""""""""""

" Define a leader key
let mapleader=" "

" Toggle autoindent/smartindent for pasting
set pastetoggle=<F2>
set showmode

" Toggle line numbers
noremap <F4> :set number!<CR>:set relativenumber!<CR>

" Toggle explorer
noremap <F6> :20%Lexplore<CR>

" Toggle showing invisible characters
noremap <leader>q :set list!<CR>
cnoremap <leader>q <C-c>:set list!<CR>

" Remove search highlighting
noremap <leader>w :nohlsearch<CR>
cnoremap <leader>w <C-c>:nohlsearch<CR>

" Ctrl+j/k moves current line down/up
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Enable blocked mappings on German keyboards for tag navigation
nnoremap <leader>l <C-]>
nnoremap g<leader>l g<C-]>
" Navigate tag back. In most Console Hosts, ^t is mapped to new tab - therefore an additional mapping is necessary.
nmap <leader>h <C-t>

" Paste register below/above current line
nnoremap <leader>p o<Esc>p
nnoremap <leader>P O<Esc>p

" Keep selection after indent in visual mode
:vnoremap < <gv
:vnoremap > >gv

" Disable Ex Mode
:nnoremap Q <Nop>

""""""""""""""
""""" Commands
""""""""""""""

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

""""""""""""""""
""""" Automation
""""""""""""""""

" Delete trailing white space on save
fun! StripTrailingWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
if has("autocmd")
    " Don't strip markdown files (where trailing whitespace indicates a line break)
    let fileTypeToIgnore = ['markdown']
    autocmd BufWritePre * if index(fileTypeToIgnore, &ft) < 0 | call StripTrailingWhitespace() | endif
endif

" active tab shows relative line numbers, inactive shows absolute line numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

