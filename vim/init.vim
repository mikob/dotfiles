let g:LanguageClient_loggingLevel = 'DEBUG'
filetype plugin on
call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'archseer/colibri.vim'
Plug 'mhartington/oceanic-next'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Heuristically set shift width options
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
Plug 'autozimu/LanguageClient-neovim', {'tag': 'binary-*-x86_64*linux*'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'maksimr/vim-jsbeautify'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'junegunn/vim-slash'
Plug 'roxma/nvim-completion-manager'

call plug#end()

set relativenumber
set number   		" show the line number of the currently active line
set tabstop=4
set shiftwidth=4
set ruler
set mouse=a
set hidden                 " allow buffer switching without saving
set scrolloff=5            " minimum lines to keep above and below cursor
set sidescrolloff=7

syntax enable

let mapleader="\<Space>"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabNoCompleteAfter = ['^', ';','\s', '{', '}', '"', "'", ':', ')', '#']

" Silent prevents the 'Hit Enter to continue' prompt...
silent! map <f2> :NERDTreeToggle<cr>
silent! map! <f2> <esc>:NERDTreeToggle<cr>
silent! tmap <f2> <c-\><c-n>:NERDTreeToggle<cr>
" Case insensitive search, without f'ing up substitutions as ignorecase and
" smartcase would
nnoremap / /\c
nnoremap ? ?\c
" This is actually ctrl-/ ... vim registers it as _ for some reason
noremap <c-_> :call NERDComment(0,"toggle")<cr>
inoremap <c-_> <esc>:call NERDComment(0,"toggle")<cr>i
noremap <c-a> <c-w>
inoremap <c-a> <esc><c-w>
noremap <c-s> :w<cr>
inoremap <c-s> <esc>:w<cr>a
" Leave vim terminal with ctrl-a and a hjkl key
tnoremap <c-a> <c-\><c-n><c-w>
" close current buffer with <leader>x
noremap <silent> <leader>x :Sayonara!<cr>

" FZF
noremap <c-p> :FZF<cr>
inoremap <c-p> <esc>:FZF<cr>
nnoremap <f3> :Buffers<cr>
tnoremap <f3> <c-\><c-n>:Buffers<cr>
nnoremap <leader>` :Marks<cr>
nnoremap b] :bnext<cr>
nnoremap b[ :bprevious<cr>

" language server
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <f4> :call LanguageClient_textDocument_rename()<CR>


" vim-better-whitespace plugin
autocmd BufEnter * EnableStripWhitespaceOnSave

" vim-gitgutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_removed = '▖'
let g:gitgutter_sign_removed_first_line = '▘'
let g:gitgutter_sign_modified = '▐'
let g:gitgutter_sign_modified_removed = '▞'

" language server options
let g:LanguageClient_serverCommands = {
	\ 'python': ['pyls'],
	\ }

" fzf options
let g:fzf_layout = { 'window': 'enew' }

colorscheme colibri
if has('nvim')
  set termguicolors
  set inccommand=split
  colors colibri
endif
