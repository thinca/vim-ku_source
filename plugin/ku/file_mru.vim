" ku source: file_mru
" Version: 0.0.0
" Copyright (C) 2008 thinca <http://d.hatena.ne.jp/thinca/>
" License: NYSL <http://www.kmonos.net/nysl/index.en.html>

if exists('g:loaded_ku_file_mru') || v:version < 700
  finish
endif
let g:loaded_ku_file_mru = 1




augroup plugin-ku-file_mru
  autocmd!
  autocmd BufEnter     * call ku#file_mru#_append()
  autocmd BufWritePost * call ku#file_mru#_append()
  autocmd BufFilePost  * call ku#file_mru#_append()
augroup END




" __END__
" vim: foldmethod=marker
