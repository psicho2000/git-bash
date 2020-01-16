" https://github.com/amix/vimrc

set tabstop=4
set shiftwidth=4
" use spaces instead of tabs
set expandtab
" show number in current line and relative number in all others
set number relativenumber   
" all: cursor may be placed after EOL
set virtualedit=all
" when turned on, show \n, \t and space
set listchars=eol:$,tab:>-,space:·
" allow a new buffer to be created when current one has not been saved yet
set hidden
  
" active tab shows relative line numbers, inactive shows absolute line numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" F5 toggles showing invisible characters
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>
