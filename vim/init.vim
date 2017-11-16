call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug '~/.vim/plugged/colibri'
Plug 'mhartington/oceanic-next'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Highlights text that will be replaced in a substitution
Plug 'osyo-manga/vim-over'
Plug 'ctrlpvim/ctrlp.vim'
" Heuristically set shift width options
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'

call plug#end()

set relativenumber
set tabstop=4
set shiftwidth=4
set ruler
syntax enable


" Silent prevents the 'Hit Enter to continue' prompt...
silent! map <F2> :NERDTreeToggle<CR>
silent! map! <F2> <ESC>:NERDTreeToggle<CR>
" Case insensitive search, without f'ing up substitutions as ignorecase and
" smartcase would
nnoremap / /\c
nnoremap ? ?\c

" vim-better-whistespace plugin
autocmd BufEnter * EnableStripWhitespaceOnSave

colorscheme solarized
if has('nvim')
  set termguicolors
  colors desert
endif
