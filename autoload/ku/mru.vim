" Settings  "{{{1
function! s:set_default(var, val)
  if !exists(a:var) || type(eval(a:var)) != type(a:val)
    execute 'let ' . a:var . ' = ' . string(a:val)
  endif
endfunction

" [ { 'path' : full_path, 'time' : localtime()}, ... ]
let s:mru_items = []


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
  if !exists('s:cache_items')
    let s:cache_items = map(copy(s:mru_items),'{
          \ "abbr" : fnamemodify(v:val.path, ":~:."),
          \ "word" : v:val.path,
          \ "menu" : strftime(g:ku_mru_time_format, v:val.time),
          \ "_ku_sort_priority" : -v:val.time
          \}')
  endif
  return s:cache_items
endfunction

" Append the current buffer to the mru list.
function! ku#mru#append()  "{{{2
  call s:load()
  let path = expand('%:p')
  if filereadable(path) && empty(&buftype)
    call insert(filter(s:mru_items, 'v:val.path != path'),
      \ {'path' : path, 'time' : localtime()} )
    if 0 < g:ku_mru_limit
      unlet s:mru_items[g:ku_mru_limit]
    endif
    call s:save()
    unlet! s:cache_items
  endif
endfunction


" Misc  "{{{1
function! s:open(bang, item)  "{{{2
  execute 'edit'.a:bang fnameescape(a:item.word)
endfunction

function! s:save()  "{{{2
  call writefile(map(copy(s:mru_items), 'string(v:val)'), g:ku_mru_file)
endfunction

function! s:load()  "{{{2
  if filereadable(g:ku_mru_file)
    let s:mru_items = filter(map(readfile(g:ku_mru_file), 'eval(v:val)'),
      \ 'filereadable(v:val.path)')[0:g:ku_mru_limit - 1]
  endif
  unlet! s:cache_items
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
