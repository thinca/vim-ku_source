" ku source: file_mru
" Version: 0.0.0
" Copyright (C) 2008 thinca <http://d.hatena.ne.jp/thinca/>
" License: NYSL <http://www.kmonos.net/nysl/index.en.html>
" Variables  "{{{1

" s:mru_files = [{'path': full_path, 'time': localtime()}, ...]

" s:cached_items = [item, ...]




function! s:set_default(var, val)
  if !exists(a:var) || type({a:var}) != type(a:val)
    let {a:var} = a:val
  endif
endfunction

call s:set_default('g:ku_file_mru_time_format', '(%x %H:%M:%S)')
call s:set_default('g:ku_file_mru_file',  expand('~/.vimru'))
call s:set_default('g:ku_file_mru_limit', 100)








" Interface  "{{{1
function! ku#file_mru#event_handler(event, ...)  "{{{2
  if a:event ==# 'SourceEnter'
    let s:cached_items = map(copy(s:mru_files), '{
    \     "abbr": fnamemodify(v:val.path, ":~:."),
    \     "word": v:val.path,
    \     "menu": strftime(g:ku_file_mru_time_format, v:val.time),
    \     "_ku_sort_priority": -v:val.time
    \   }')
  else
    return call('ku#default_event_handler', [a:event] + a:000)
  endif
endfunction




function! ku#file_mru#action_table()  "{{{2
  return ku#file#action_table()
endfunction




function! ku#file_mru#key_table()  "{{{2
  return ku#file#key_table()
endfunction




function! ku#file_mru#gather_items(pattern)  "{{{2
  return s:cached_items
endfunction








" Misc  "{{{1
function! ku#file_mru#_append()  "{{{2
  " Append the current buffer to the mru list.
  let path = expand('%:p')
  if !filereadable(path) || !empty(&l:buftype)
    return
  endif

  call s:load()
  call insert(filter(s:mru_files, 'v:val.path !=# path'),
  \           {'path': path, 'time': localtime()})
  if 0 < g:ku_file_mru_limit
    unlet s:mru_files[g:ku_file_mru_limit]
  endif
  call s:save()
endfunction




function! s:save()  "{{{2
  call writefile(map(copy(s:mru_files), 'string(v:val)'), g:ku_file_mru_file)
endfunction




function! s:load()  "{{{2
  if filereadable(g:ku_file_mru_file)
    let s:mru_files = filter(map(readfile(g:ku_file_mru_file), 'eval(v:val)'),
      \ 'filereadable(v:val.path)')[0:g:ku_file_mru_limit - 1]
  endif
endfunction

call s:load()  " To initialize s:mru_files whenever this file is loaded.








" __END__  "{{{1
" vim: foldmethod=marker
