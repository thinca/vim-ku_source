" ku source: file_mru
" Version: 0.1.3
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if exists('g:loaded_ku_source_file_mru') || v:version < 700
  finish
endif
let g:loaded_ku_source_file_mru = 1



call ku#define_source({
\   'default_action_table': {
\     'file_mru/delete': function('ku#source#file_mru#action_delete'),
\   },
\   'default_key_table': {
\     'd': 'file_mru/delete',
\     "\<C-d>": 'file_mru/delete',
\   },
\   'sorters': [function('ku#source#file_mru#sort')],
\   'gather_candidates': function('ku#source#file_mru#gather_candidates'),
\   'kinds': ['file', 'buffer'],
\   'name': 'file_mru',
\ })



augroup plugin-ku-source-file_mru
  autocmd!
  autocmd BufEnter,BufWritePost,BufFilePost * call ku#source#file_mru#_append()
augroup END



" __END__
" vim: foldmethod=marker
