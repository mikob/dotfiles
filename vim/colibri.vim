" Vim color file
" Author: Blaž Hrastnik
"
" Note:

" Bootstrap:

hi clear
if exists("syntax_on") | syntax reset | endif
set background=dark
let g:colors_name = "colibri"

" colibri Colorscheme for GUI

let s:colibri = {}

" foreground #a4a0e8 (non active window)
" lighter foreground #dbbfef (active window)
" #5a5977 neutral window tone
"
let s:colibri.foreground      = ["#a4a0e8", 1]
let s:colibri.background_dark = ["#281733", 1]
let s:colibri.background      = ["#3b224c", 1]
"let s:colibri.background      = ["#311D40", 1] " HSB with B at 25 (instead of 30)
"let s:colibri.background = ["#ffffff", 1]
let s:colibri.background_light = ["#452859", 1]

" ui tones
let s:colibri.disabled = s:colibri.foreground
let s:colibri.active = ["#dbbfef", 1]
let s:colibri.window = s:colibri.background_light
let s:colibri.linenr = ["#5a5977", 1]
let s:colibri.highlight  = ["#00CCCC", 1] " is like a blueish neon 00CCCC
let s:colibri.highlight  = ["#802F00", 1]

" #D7F4A8?
let s:colibri.error     = ["#f47868", 209]
let s:colibri.warning   = ["#ffcd1c", 220]

let s:colibri.builtin  = ["#FFFFFF", 1]
let s:colibri.string   = ["#cccccc", 1]
let s:colibri.proper = ["#FFFFFF", 1]
let s:colibri.constant   = ["#9FF28F", 1] " 81EECF / 7FB998 / 9FF28F! -- 5fe7b7
let s:colibri.bool     = ["#FFFFFF", 1]
let s:colibri.func     = ["#FFFFFF", 1]
let s:colibri.punct    = ["#dbbfef", 1]
"let s:colibri.keyword  = ["#5fe7b7", 1]
"let s:colibri.keyword  = ["#77B56B", 1]
let s:colibri.keyword  = ["#ECCDBA", 1]
let s:colibri.comment  = ["#697C81", 1]
let s:colibri.number   = ["#E8DCA0", 1]

let s:colibri.special  = ["#EFBA5D", 1]

"let s:colibri.foreground    = ["#ffffff", 1]
"let s:colibri.builtin  = ["#a4a0e8", 1]
"let s:colibri.proper   = ["#a4a0e8", 1]
"let s:colibri.bool     = ["#a4a0e8", 1]
"let s:colibri.func     = ["#a4a0e8", 1]
" }}}
" Helpers: {{{

function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp

  let highlightString = 'hi ' . a:group . ' '

  " Settings for highlight group ctermfg & guifg
  if strlen(a:fg)
    if a:fg == 'fg'
      let highlightString .= 'guifg=fg ctermfg=fg '
    elseif a:fg == 'none'
      let highlightString .= 'guifg=NONE ctermfg=NONE '
    else
      let color = get(s:colibri, a:fg)
      let highlightString .= 'guifg=' . color[0] . ' ctermfg=' . color[1] . ' '
    endif
  endif

  " Settings for highlight group termbg & guibg
  if a:0 >= 1 && strlen(a:1)
    if a:1 == 'bg'
      let highlightString .= 'guibg=bg ctermbg=bg '
    elseif a:1 == 'none'
      let highlightString .= 'guibg=NONE ctermbg=NONE '
    else
      let color = get(s:colibri, a:1)
      let highlightString .= 'guibg=' . color[0] . ' ctermbg=' . color[1] . ' '
    endif
  endif

  " Settings for highlight group cterm & gui
  if a:0 >= 2 && strlen(a:2)
    let highlightString .= 'gui=' . a:2 . ' cterm=' . a:2 . ' '
  endif

  " Settings for highlight guisp
  if a:0 >= 3 && strlen(a:3)
    let color = get(s:birds, a:3)
    let highlightString .= 'guisp=#' . color[0] . ' '
  endif

  " echom highlightString

  execute highlightString
endfunction

call s:HL("Normal", 'foreground', 'background', "none")

call s:HL('VertSplit', 'window', 'window', '')

"call s:HL('Cursor',       'background', 'cursor',    'none') " vCursor, iCursor
call s:HL('Visual',       '',           'highlight', 'none')

call s:HL("CursorLine", '', 'window', "none")
call s:HL("CursorColumn", '', 'window', "none")
call s:HL("ColorColumn", '', 'window', "none")

" TODO: Tabline

" - Gutter
call s:HL("LineNr", 'linenr', '', '')
" CursorLineNr
call s:HL('SignColumn',   'active',  'window',      'none')
call s:HL('FoldColumn',   'active',  'window',      'none')
call s:HL('Folded',    'comment',  'background_light',     'none')

" TODO: MatchParen

call s:HL("StatusLine", 'background_dark', 'active', '')
call s:HL("StatusLineNC", 'background_dark', 'disabled', '')

" TODO: Directory

call s:HL("Title", 'foreground', '', "bold")

call s:HL('ErrorMsg', 'error', 'none', 'bold')
call s:HL('WarningMsg', 'warning', 'none')
" TODO: ModeMsg, Question, MoreMsg

" TODO: Tag

" - Completion menu
call s:HL('Pmenu',    'foreground', 'window', 'none')
"call s:HL('Pmenu',    'active', 'linenr', 'none')
call s:HL('PmenuSel', 'active', 'background_dark', 'none')

" Tildes below buffer
call s:HL('NonText', 'window', '', 'none')

" Special keys, e.g. some of the chars in 'listchars'. See ':h listchars'.
" TODO: SpecialKey

" - Diffs
let s:colibri.diff_green  = ["#35BF86", 1]
let s:colibri.diff_red  = ["#F22C86", 1]
let s:colibri.diff_change = ["#69A0F3", 1]
let s:colibri.dblue   = ["#3B0FBF", 1] " 2CD5F2
call s:HL('DiffAdd', 'diff_green', 'background_light', 'bold')
call s:HL('DiffDelete', 'diff_red', 'background_light', '')
call s:HL('DiffChange', 'foreground', 'dblue', '')
call s:HL('DiffText', 'dblue', 'diff_change', 'bold')

call s:HL('DiffAdded', 'diff_green', '', 'bold')
call s:HL('DiffRemoved', 'diff_red', '', '')
call s:HL('DiffChanged', 'foreground', 'dblue', '')


