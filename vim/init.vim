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
Plug 'maksimr/vim-jsbeautify'

call plug#end()

set relativenumber
set tabstop=4
set shiftwidth=4
set ruler
set mouse=a
set hidden                 " allow buffer switching without saving

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
inoremap <C-_> <ESC>:call NERDComment(0,"toggle")<CR>i
noremap <C-p> :FZF<CR>
inoremap <C-p> <ESC>:FZF<CR>
noremap <C-a> <C-w>
inoremap <C-a> <ESC><C-w>
noremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>a
" Leave vim terminal with ctrl-a and a hjkl key
tnoremap <C-a> <C-\><C-n><C-w>

" vim-better-whitespace plugin
autocmd BufEnter * EnableStripWhitespaceOnSave

" vim-gitgutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_removed = '▖'
let g:gitgutter_sign_removed_first_line = '▘'
let g:gitgutter_sign_modified = '▐'
let g:gitgutter_sign_modified_removed = '▞'

" fzf options
let g:fzf_layout = { 'window': 'enew' }

colorscheme colibri
if has('nvim')
  set termguicolors
  set inccommand=split
  colors colibri
endif
