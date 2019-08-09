packadd vim-lsp
packadd ale

let b:ale_linters = ['clangd']
setlocal omnifunc=lsp#complete
setlocal commentstring=/*\ %s\ */

match ColorColumn /\%>80v.\+/
