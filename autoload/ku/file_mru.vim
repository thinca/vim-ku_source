" ku source: file_mru
" Version: 0.1.0
" Author : thinca <http://d.hatena.ne.jp/thinca/>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>
" Variables  "{{{1

" [ { 'path' : full_path, 'time' : localtime()}, ... ]
let s:mru_files = []

let s:mru_file_mtime = 0  " the last modified time of the mru file.



function! s:set_default(var, val)
  if !exists(a:var) || type({a:var}) != type(a:val)
    let {a:var} = a:val
  endif
endfunction

call s:set_default('g:ku_file_mru_time_format', '(%x %H:%M:%S)')
call s:set_default('g:ku_file_mru_file',  expand('~/.vimru'))
call s:set_default('g:ku_file_mru_limit', 100)



function! ku#file_mru#available_sources()
  return ['file_mru']
endfunction





" Interface  "{{{1
function! ku#file_mru#action_table(ext)  "{{{2
  return extend(ku#file#action_table(a:ext),
  \ {'delete': 'ku#file_mru#action_delete'})
endfunction




function! ku#file_mru#key_table(ext)  "{{{2
  return extend(ku#file#key_table(a:ext),
  \ {"\<C-d>": 'delete', 'd': 'delete'})
endfunction



function! ku#file_mru#gather_items(ext, pattern)  "{{{2
  call s:load()
  return map(copy(s:mru_files), '{
  \     "abbr": fnamemodify(v:val.path, ":~:."),
  \     "word": v:val.path,
  \     "menu": strftime(g:ku_file_mru_time_format, v:val.time),
  \     "ku__sort_priority": -v:val.time
  \   }')
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




function! ku#file_mru#action_delete(item)
  let i = 0
  for _ in s:mru_files
    if _.path ==# a:item.word
      unlet! s:mru_files[i]
      call s:save()
      return
    endif
    let i += 1
  endfor
endfunction




function! s:save()  "{{{2
  call writefile(map(copy(s:mru_files), 'string(v:val)'), g:ku_file_mru_file)
  let s:mru_file_mtime = getftime(g:ku_file_mru_file)
endfunction




function! s:load()  "{{{2
  if filereadable(g:ku_file_mru_file)
  \ && s:mru_file_mtime != getftime(g:ku_file_mru_file)
    let s:mru_files = filter(map(readfile(g:ku_file_mru_file), 'eval(v:val)'),
    \ 'filereadable(v:val.path)')[0:g:ku_file_mru_limit - 1]
    let s:mru_file_mtime = getftime(g:ku_file_mru_file)
  endif
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
