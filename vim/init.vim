filetype plugin on
call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'archseer/colibri.vim'
Plug 'mhartington/oceanic-next'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Heuristically set shift width options
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'

call plug#end()

set relativenumber
set tabstop=4
set shiftwidth=4
set ruler
syntax enable

let mapleader="\<Space>"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabNoCompleteAfter = ['^', ';','\s', '{', '}', '"', "'", ':', ')', '#']

" Silent prevents the 'Hit Enter to continue' prompt...
silent! map <F2> :NERDTreeToggle<CR>
silent! map! <F2> <ESC>:NERDTreeToggle<CR>
" Case insensitive search, without f'ing up substitutions as ignorecase and
" smartcase would
nnoremap / /\c
nnoremap ? ?\c

" vim-better-whistespace plugin
autocmd BufEnter * EnableStripWhitespaceOnSave

colorscheme colibri
if has('nvim')
  set termguicolors
  set inccommand=split
  colors colibri
endif
