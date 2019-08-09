packadd vim-lsp
packadd ale

let b:ale_linters = ['gopls']
setlocal omnifunc=lsp#complete

match ColorColumn /\%>80v.\+/
