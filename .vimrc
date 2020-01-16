" https://github.com/amix/vimrc

set tabstop=4
set shiftwidth=4
set expandtab
set number relativenumber
set virtualedit=all
set listchars=eol:$,tab:>-,space:·

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>
