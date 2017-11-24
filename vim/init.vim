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
Plug '~/.fzf'
Plug 'airblade/vim-gitgutter'

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
" This is actually ctrl-/ ... vim registers it as _ for some reason
noremap <C-_> :call NERDComment(0,"toggle")<CR>
noremap <C-p> :FZF<CR>

" vim-better-whitespace plugin
autocmd BufEnter * EnableStripWhitespaceOnSave

" vim-gitgutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_removed = '▖'
let g:gitgutter_sign_removed_first_line = '▘'
let g:gitgutter_sign_modified = '▐'
let g:gitgutter_sign_modified_removed = '▞'

colorscheme colibri
if has('nvim')
  set termguicolors
  set inccommand=split
  colors colibri
endif
