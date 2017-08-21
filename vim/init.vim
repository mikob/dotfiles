set relativenumber
set tabstop=4
set shiftwidth=4
set ruler
syntax enable

" Theme
call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug '~/.vim/plugged/colibri'
Plug 'mhartington/oceanic-next'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

call plug#end()
colorscheme solarized

silent! nmap <C-p> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>

let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"

if has('nvim')
  set termguicolors
  colors desert
endif

