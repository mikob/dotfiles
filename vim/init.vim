set termguicolors
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
Plug 'osyo-manga/vim-over'

call plug#end()
colorscheme colibri

if has('nvim')
  set termguicolors
  colors colibri
endif

