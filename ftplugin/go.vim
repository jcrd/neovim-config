packadd ale

if executable('go') && executable('gopls')
    let b:ale_linters = ['gopls']
endif

match ColorColumn /\%>80v.\+/
