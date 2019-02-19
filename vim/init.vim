let g:LanguageClient_loggingLevel = 'DEBUG'
filetype plugin on
call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'archseer/colibri.vim'
Plug 'mhartington/oceanic-next'
Plug 'machakann/vim-sandwich'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Heuristically set shift width options
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'maksimr/vim-jsbeautify'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'junegunn/vim-slash'
Plug 'leafgarland/typescript-vim'
Plug 'vim-airline/vim-airline'
" TODO: remove this now that we have langugage server support?
"if has("python3")
	"Plug 'roxma/nvim-completion-manager'
"endif
Plug 'iamcco/markdown-preview.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'tpope/vim-unimpaired'
Plug 'rakr/vim-one'
Plug 'mattn/emmet-vim'
Plug 'terryma/vim-multiple-cursors'

call plug#end()

" set relativenumber
set number   		" show the line number of the currently active line
set tabstop=4
set shiftwidth=4
set expandtab
set ruler
set mouse=a
set hidden                 " allow buffer switching without saving
set scrolloff=5            " minimum lines to keep above and below cursor
set sidescrolloff=7

syntax enable

nnoremap <SPACE> <Nop>
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
tnoremap <c-^> <c-\><c-n><c-^>
" close current buffer with <leader>x
noremap <silent> <leader>x :Sayonara!<cr>
" Select last pasted
nnoremap gp `[v`]

" FZF
noremap <c-p> :FZF<cr>
inoremap <c-p> <esc>:FZF<cr>
nnoremap <f3> :Buffers<cr>
tnoremap <f3> <c-\><c-n>:Buffers<cr>
nnoremap <leader>` :Marks<cr>

" buffers
nnoremap b] :bnext<cr>
nnoremap b[ :bprevious<cr>

" vim-better-whitespace plugin
autocmd BufEnter * EnableStripWhitespaceOnSave

" vim-gitgutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_removed = '▖'
let g:gitgutter_sign_removed_first_line = '▘'
let g:gitgutter_sign_modified = '▐'
let g:gitgutter_sign_modified_removed = '▞'

" autozimu language server/deoplete options
" \ 'javascript': ['node_modules/.bin/flow-language-server', '---stdio', '--try-flow-bin'],
"let g:LanguageClient_serverCommands = {
	"\ 'python': ['pyls'],
	"\ 'javascript': ['javascript-typescript-stdio'],
	"\ 'typescript': ['javascript-typescript-stdio'],
	"\ 'elixir': ['/opt/elixir-ls/language_server.sh'],
	"\ }
    " pip install python-language-server

nnoremap <silent> K :LspHover<CR>
nnoremap <leader>d :LspDefinition<CR>
nnoremap <silent> <f4> :LspRename<CR>

" zoom
nnoremap <leader>z :tabedit %<CR>
nnoremap <leader>Z :tabclose<CR>

let g:deoplete#enable_at_startup = 1
let g:lsp_async_completion = 1

let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '⚠'}
let g:lsp_signs_hint = {'text': '♢'}

au User lsp_setup call lsp#register_server({
	\ 'name': 'pyls',
	\ 'cmd': {server_info->['/home/mikob/.virtualenvs/avail-check-worker-92uV263A/bin/pyls']},
	\ 'whitelist': ['python'],
	\ })

if executable('javascript-typescript-stdio')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'javascript-typescript-stdio',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'javascript-typescript-stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript'],
        \ })
endif

if executable('flow-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'flow-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'flow-language-server --stdio']},
		\ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript'],
        \ })
endif

" TODO:
if executable('elixir-language-server')
	au User lsp_setup call lsp#register_server({
			\ 'name': 'elixir-ls',
			\ 'cmd': {server_info->[&shell, &shellcmdflag, '~/src/elixir-ls/language_server.sh']},
			\ 'whitelist': ['elixir', 'eelixir'],
			\ })
endif


" fzf options
let g:fzf_layout = { 'window': 'enew' }

" statusline
let g:airline_section_z = '%o %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v'

" custom filetypes
autocmd BufNewFile,BufRead *.tag set syntax=html
autocmd BufNewFile,BufRead *.vue set syntax=typescript

" misspellings
iabbrev teh the

" Colors
colorscheme colibri
if has('nvim')
	set termguicolors
	set inccommand=split
	colors colibri

	" use existing vim instance when running `git commit`
	let $VISUAL = 'nvr --remote-wait'
endif

let g:terminal_color_0  = '#2e3436'
let g:terminal_color_1  = '#F63333'
let g:terminal_color_2  = '00CD00'
let g:terminal_color_3  = '#c4a000'
let g:terminal_color_4  = '#57A3E4'
let g:terminal_color_5  = '#75507b'
let g:terminal_color_6  = '#0b939b'
let g:terminal_color_7  = '#d3d7cf'
let g:terminal_color_8  = '#555753'
let g:terminal_color_9  = '#FF6F6F'
let g:terminal_color_10 = '#00FF00'
let g:terminal_color_11 = '#fce94f'
let g:terminal_color_12 = '#8CC9FF'
let g:terminal_color_13 = '#ad7fa8'
let g:terminal_color_14 = '#00f5e9'
let g:terminal_color_15 = '#eeeeec'
