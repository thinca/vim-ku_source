" ku source: file_mru
" Version: 0.1.3
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>
" Variables  "{{{1

" The version of MRU file format.
let s:VERSION = '0.2.0'

" [ [ full_path, time], ... ]
let s:mru_files = []

let s:mru_file_mtime = 0  " the last modified time of the mru file.



function! s:set_default(var, val)  "{{{2
  if !exists(a:var) || type({a:var}) != type(a:val)
    let {a:var} = a:val
  endif
endfunction

call s:set_default('g:ku_source_file_mru_time_format', '(%x %H:%M:%S)')
call s:set_default('g:ku_source_file_mru_file',  expand('~/.vimru'))
call s:set_default('g:ku_source_file_mru_limit', 100)



" Interface  {{{1
function! ku#source#file_mru#gather_candidates(args)  "{{{2
  call s:load()
  return map(copy(s:mru_files), '{
  \     "abbr": fnamemodify(v:val[0], ":~:."),
  \     "word": v:val[0],
  \     "menu": strftime(g:ku_source_file_mru_time_format, v:val[1]),
  \     "ku_file_mru_time": v:val[1]
  \   }')
endfunction




" Actions  {{{1
function! ku#source#file_mru#action_delete(item)  "{{{2
  let i = 0
  for _ in s:mru_files
    if _[0] ==# a:item.word
      unlet! s:mru_files[i]
      call s:save()
      return
    endif
    let i += 1
  endfor
endfunction



" Sorters  {{{1
function! ku#source#file_mru#sort(lcandidates, args)
  return sort(a:lcandidates, 's:compare')
endfunction



function! s:compare(candidate_a, candidate_b)
  return a:candidate_b.ku_file_mru_time - a:candidate_a.ku_file_mru_time
endfunction




" Misc  {{{1
function! ku#source#file_mru#_append()  "{{{2
  " Append the current buffer to the mru list.
  let path = expand('%:p')
  if &l:buftype != '' || glob(path, 1) == ''
    return
  endif

  call s:load()
  call insert(filter(s:mru_files, 'v:val[0] !=# path'),
  \           [path, localtime()])
  if 0 < g:ku_source_file_mru_limit
    unlet s:mru_files[g:ku_source_file_mru_limit]
  endif
  call s:save()
endfunction




function! s:save()  "{{{2
  call writefile([s:VERSION] + map(copy(s:mru_files), 'join(v:val, "\t")'),
  \              g:ku_source_file_mru_file)
  let s:mru_file_mtime = getftime(g:ku_source_file_mru_file)
endfunction




function! s:load()  "{{{2
  if filereadable(g:ku_source_file_mru_file)
  \  && s:mru_file_mtime != getftime(g:ku_source_file_mru_file)
    let [ver; s:mru_files] = readfile(g:ku_source_file_mru_file)
    if ver !=# s:VERSION
      echohl WarningMsg
      echomsg 'Sorry, the version of MRU file is old.  Clears the MRU list.'
      echohl None
      let s:mru_files = []
      return
    endif
    let s:mru_files =
    \   filter(map(s:mru_files[0 : g:ku_source_file_mru_limit - 1],
    \              'split(v:val, "\t")'), 'glob(v:val[0], 1) != ""')
    let s:mru_file_mtime = getftime(g:ku_source_file_mru_file)
  endif
endfunction





" __END__  "{{{1
" vim: foldmethod=marker
