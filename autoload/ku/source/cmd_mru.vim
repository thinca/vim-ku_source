" ku source: cmd/mru
" Version: 0.1.0
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>


" Interface  "{{{1
function! ku#source#cmd_mru#gather_candidates(args)  "{{{2
  let _ = []
  let type = matchstr(a:args.source.name, '^\w*\ze/mru$')
  let prefix = {'cmd' : ':', 'search' : '/'}[type]
  let max = histnr(type)
  let max_digit = strlen(max)
  for i in range(1, max)
    let cmd = histget(type, i)
    if cmd != ''
      call add(_, {
      \ 'word': prefix . cmd,
      \ 'menu': printf('%' . max_digit . 'd%s%s', i, prefix, type),
      \ 'ku_cmd/mru_index': i
      \ })
    endif
  endfor

  return _
endfunction




" Actions  "{{{1
function! ku#source#cmd_mru#action_execute(item) "{{{3
  let word = a:item.word
  call histadd(word[0], word[1:])
  call feedkeys(word . "\<CR>", 'n')
endfunction




function! ku#source#cmd_mru#action_input(item) "{{{3
  call feedkeys(a:item.word, 'n')
endfunction




function! ku#source#cmd_mru#action_delete(item)
  call histdel(a:item.word[0], -a:item.ku__sort_priority)
endfunction



" Sorters  {{{1
function! ku#source#cmd_mru#sort(lcandidates, args)
  return sort(a:lcandidates, 's:compare')
endfunction



function! s:compare(candidate_a, candidate_b)
  return a:candidate_b['ku_cmd/mru_index'] - a:candidate_a['ku_cmd/mru_index']
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
