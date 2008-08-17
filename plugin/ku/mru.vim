if exists('loaded_ku_mru') || v:version < 700
  finish
endif
let loaded_ku_mru = 1

augroup plugin-ku-mru
  autocmd!
  autocmd BufEnter     * call ku#mru#append()
  autocmd BufWritePost * call ku#mru#append()
  autocmd BufFilePost  * call ku#mru#append()
augroup END
