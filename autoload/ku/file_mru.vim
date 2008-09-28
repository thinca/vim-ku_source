" ku source: file_mru
" Version: 0.0.0
" Copyright (C) 2008 thinca <http://d.hatena.ne.jp/thinca/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Variables  "{{{1

function! s:set_default(var, val)
  if !exists(a:var) || type(eval(a:var)) != type(a:val)
    execute 'let ' . a:var . ' = ' . string(a:val)
  endif
endfunction

" [ { 'path' : full_path, 'time' : localtime()}, ... ]
let s:mru_files = []

" s:cached_items = [item, ...]


call s:set_default('g:ku_mru_time_format', '(%x %H:%M:%S)')
call s:set_default('g:ku_mru_file',  expand('~/.vimru'))
call s:set_default('g:ku_mru_limit', 100)








" Interface  "{{{1
function! ku#mru#event_handler(event, ...)  "{{{2
  if a:event ==# 'SourceEnter'
    call s:load()
  else
    return call('ku#default_event_handler', [a:event] + a:000)
  endif
endfunction




function! ku#mru#action_table()  "{{{2
  return {
  \   'default': 'ku#mru#action_open',
  \   'open!': 'ku#mru#action_open_x',
  \   'open': 'ku#mru#action_open',
  \ }
endfunction




function! ku#mru#key_table()  "{{{2
  return {
  \   "\<C-o>": 'open',
  \   'O': 'open!',
  \   'o': 'open',
  \ }
endfunction




function! ku#mru#gather_items(pattern)  "{{{2
  if !exists('s:cached_items')
    let s:cached_items = map(copy(s:mru_files),'{
          \ "abbr" : fnamemodify(v:val.path, ":~:."),
          \ "word" : v:val.path,
          \ "menu" : strftime(g:ku_mru_time_format, v:val.time),
          \ "_ku_sort_priority" : -v:val.time
          \}')
  endif
  return s:cached_items
endfunction




function! ku#mru#append()  "{{{2
  " Append the current buffer to the mru list.
  call s:load()
  let path = expand('%:p')
  if filereadable(path) && empty(&buftype)
    call insert(filter(s:mru_files, 'v:val.path != path'),
      \ {'path' : path, 'time' : localtime()} )
    if 0 < g:ku_mru_limit
      unlet s:mru_files[g:ku_mru_limit]
    endif
    call s:save()
    unlet! s:cached_items
  endif
endfunction








" Misc  "{{{1
function! s:open(bang, item)  "{{{2
  execute 'edit'.a:bang fnameescape(a:item.word)
endfunction




function! s:save()  "{{{2
  call writefile(map(copy(s:mru_files), 'string(v:val)'), g:ku_mru_file)
endfunction




function! s:load()  "{{{2
  if filereadable(g:ku_mru_file)
    let s:mru_files = filter(map(readfile(g:ku_mru_file), 'eval(v:val)'),
      \ 'filereadable(v:val.path)')[0:g:ku_mru_limit - 1]
  endif
  unlet! s:cached_items
endfunction




" Actions  "{{{2
function! ku#mru#action_open(item)  "{{{3
  call s:open('', a:item)
endfunction


function! ku#mru#action_open_x(item)  "{{{3
  call s:open('!', a:item)
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
