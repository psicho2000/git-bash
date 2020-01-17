" https://github.com/amix/vimrc

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
" block: Ctrl+V marks whole block (even across EOL) / all (extends block mode): cursor may be additionally placed after EOL
set virtualedit=block
" when turned on, show \n, \t and space
set listchars=eol:$,tab:>-,space:·
" allow a new buffer to be created when current one has not been saved yet
set hidden
" autocompletion
set wildmenu
set wildmode=list:longest,full
" highlight search results and use search behaviour as in modern browsers
set hlsearch
set incsearch

""""""""""""""""""
""""" Key mappings
""""""""""""""""""

" F5 toggles showing invisible characters
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

" Ctrl+j/k moves current line down/up
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

""""""""""""""""
""""" Automation
""""""""""""""""

" Delete trailing white space on save
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
if has("autocmd")
    " instead of *.*, you may define desired filetypes like *.java,*.yml,*.ts
    autocmd BufWritePre *.* call CleanExtraSpaces()
endif

" active tab shows relative line numbers, inactive shows absolute line numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

