" https://github.com/amix/vimrc

if !empty(glob("$VIMRUNTIME/defaults.vim"))
    source $VIMRUNTIME/defaults.vim
endif

""""""""""""""
""""" Settings
""""""""""""""

" set encoding to utf-8
set encoding=utf-8
" minimal number of lines to always keep visible above the cursor when scrolling
set scrolloff=5
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
" for smartcase to work, ignorecase must be set first
set hlsearch
set incsearch
set ignorecase
set smartcase
" Use global directory for swap files
set directory^=/tmp/vimswap//
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
" Enable mouse support
set mouse=a
" Enable cursor blinking
set guicursor+=a:blinkwait175-blinkoff150-blinkon175
" Always highlight current line
set cursorline
highlight CursorLine cterm=NONE ctermbg=236
highlight CursorLineNr cterm=NONE ctermbg=236 ctermfg=251
highlight LineNr cterm=None ctermbg=235 ctermfg=246
" Set default background
set background=light

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view

""""""""""""""""""
""""" Key mappings
""""""""""""""""""

" https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
" However, mapping Alt+J/K leads to bad behaviour after quickly pessing Esc + J/K in insert mode, because the mapping then overlaps

" Define a leader key
let mapleader=" "

" Toggle autoindent/smartindent for pasting
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Toggle explorer
noremap <F6> :20%Lexplore<CR>

" Toggle showing invisible characters
noremap <leader>w :set list!<CR>
cnoremap <leader>w <C-c>:set list!<CR>

" Remove search highlighting
noremap <leader>q :nohlsearch<CR>
cnoremap <leader>q <C-c>:nohlsearch<CR>

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
nnoremap <leader>o o<Esc>p
nnoremap <leader>O O<Esc>p

" Paste register 0
nnoremap <leader>p "0p
nnoremap <leader>P "0P
vnoremap <leader>p "0p
vnoremap <leader>P "0P

" Count number of occurrences of word under cursor
nnoremap <leader>n :%s/<c-r><c-w>//gn<cr>
" Count number of occurrences of visual selection
vnoremap <leader>n :<c-u>%s/<c-r>*//gn<cr>

" Keep selection after indent in visual mode
:vnoremap < <gv
:vnoremap > >gv

" Reload config
nnoremap <leader><C-r> :so $HOME/.vimrc<cr>

" Disable Ex Mode
:nnoremap Q <Nop>

" Experimental
" Replace all occurrences of current word
nmap <leader>x :%s/<C-r><C-w>//g<Left><Left>
" Open Terminal in new split window
nmap <leader>tv :vs<cr>:terminal<cr>i
nmap <leader>th :sp<cr>:terminal<cr>i
" Insert single character
nnoremap <M-i> i_<Esc>r

" https://github.com/nvie/vim-togglemouse/blob/master/plugin/toggle_mouse.vim
" Toggles mouse mode and line numbers
" Only do this when not done yet for this buffer
if !exists("b:loaded_toggle_copy_mode")
    let b:loaded_toggle_copy_mode = 1
    fun! s:ToggleCopyMode()
        if !exists("s:old_mouse")
            let s:old_mouse = "a"
        endif

        if &mouse == ""
            let &mouse = s:old_mouse
            echo "Mouse is for Vim (" . &mouse . ")"
        else
            let s:old_mouse = &mouse
            let &mouse=""
            echo "Mouse is for terminal"
        endif
        set number!
        set relativenumber!
    endfunction
    noremap <F12> :call <SID>ToggleCopyMode()<CR>
    inoremap <F12> <Esc>:call <SID>ToggleCopyMode()<CR>a
endif

""""""""""""""
""""" Commands
""""""""""""""

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

""""""""""""""""
""""" Automation
""""""""""""""""

" Jump to the last position when opening a file
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$")
    \ |   exe "normal! g'\""
    \ | endif

" Delete trailing white space on save
fun! StripTrailingWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
augroup StripTrailingWhitespace
    autocmd!
    " Don't strip markdown files (where trailing whitespace indicates a line break)
    let fileTypeToIgnore = ['markdown']
    autocmd BufWritePre * if index(fileTypeToIgnore, &ft) < 0 | call StripTrailingWhitespace() | endif
augroup END

" active tab shows relative line numbers, inactive shows absolute line numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Set cursor back to beam (vertical bar) when leaving vim.
" Not necessary for zsh, where the cursor is set automatically, but for bash.
autocmd VimLeave * set guicursor=a:ver1-blinkon1
