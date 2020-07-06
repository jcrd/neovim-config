packadd vim-lsp
packadd ale

let b:ale_fixers = ['black']
setlocal omnifunc=lsp#complete

match ColorColumn /\%>80v.\+/
