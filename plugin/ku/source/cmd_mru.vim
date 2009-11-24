" ku source: cmd/mru
" Version: 0.1.0
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if exists('g:loaded_ku_source_cmd_mru')
  finish
endif
let g:loaded_ku_source_cmd_mru = 1

let s:save_cpo = &cpo
set cpo&vim



call ku#define_source({
\   'default_action_table': {
\     'default': function('ku#source#cmd_mru#action_execute'),
\     'execute': function('ku#source#cmd_mru#action_execute'),
\     'input':   function('ku#source#cmd_mru#action_input'),
\     'delete':  function('ku#source#cmd_mru#action_delete'),
\   },
\   'default_key_table': {
\     'e': 'execute',
\     "\<C-e>": 'execute',
\     'i': 'input',
\     "\<C-i>": 'input',
\     'd': 'delete',
\     "\<C-d>": 'delete',
\   },
\   'gather_candidates': function('ku#source#cmd_mru#gather_candidates'),
\   'name': 'cmd/mru',
\ })



call ku#define_source({
\   'default_action_table': {
\     'default': function('ku#source#cmd_mru#action_execute'),
\     'execute': function('ku#source#cmd_mru#action_execute'),
\     'input':   function('ku#source#cmd_mru#action_input'),
\     'delete':  function('ku#source#cmd_mru#action_delete'),
\   },
\   'default_key_table': {
\     'e': 'execute',
\     "\<C-e>": 'execute',
\     'i': 'input',
\     "\<C-i>": 'input',
\     'd': 'delete',
\     "\<C-d>": 'delete',
\   },
\   'gather_candidates': function('ku#source#cmd_mru#gather_candidates'),
\   'name': 'search/mru',
\ })



let &cpo = s:save_cpo
unlet s:save_cpo
