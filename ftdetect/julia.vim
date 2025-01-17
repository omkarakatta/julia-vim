if v:version < 704
  " NOTE: this line fixes an issue with the default system-wide lisp ftplugin
  "       which didn't define b:undo_ftplugin on older Vim versions
  "       (*.jl files are recognized as lisp)
  autocmd BufRead,BufNewFile *.jl    let b:undo_ftplugin = "setlocal comments< define< formatoptions< iskeyword< lisp<"
endif

autocmd BufRead,BufNewFile *.jl      set filetype=julia

autocmd FileType *.jl                   call LaTeXtoUnicode#Refresh()
autocmd BufNew *.jl                     call LaTeXtoUnicode#Refresh()
autocmd BufEnter *.jl                   call LaTeXtoUnicode#Refresh()
autocmd CmdwinEnter *.jl                call LaTeXtoUnicode#Refresh()

" This autocommand is used to postpone the first initialization of LaTeXtoUnicode as much as possible,
" by calling LaTeXtoUnicode#SetTab and LaTeXtoUnicode#SetAutoSub only at InsertEnter or later
function! s:L2UTrigger()
  augroup L2UInit
    autocmd!
    autocmd InsertEnter *.jl            let g:did_insert_enter = 1 | call LaTeXtoUnicode#Init(0)
  augroup END
endfunction
autocmd BufEnter *.jl                   call s:L2UTrigger()

function! s:HighlightJuliaMarkdown()
  if !exists('g:markdown_fenced_languages')
    let g:markdown_fenced_languages = []
  endif
  if index(g:markdown_fenced_languages, 'julia') == -1
    call add(g:markdown_fenced_languages, 'julia')
  endif
endfunction
autocmd BufRead,BufNewFile *.jmd     call s:HighlightJuliaMarkdown()
autocmd BufRead,BufNewFile *.jmd     set filetype=markdown
