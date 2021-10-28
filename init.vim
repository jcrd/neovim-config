" set command-line height to avoid press-enter issue
" set cmdheight=2

" maintain undo history between sessions
set undofile

" use nvim's data directory settings for vim
if !has('nvim')
    set directory=$XDG_DATA_HOME/vim/swap//
    set undodir=$XDG_DATA_HOME/vim/undo
    set backupdir=.,$XDG_DATA_HOME/vim/backup
endif

" set clipboard to X11 clipboard selection
set clipboard=unnamedplus

" change working dir to that of current file
" set autochdir

" split window below and to the right
set splitbelow
set splitright

" allow any buffer to be hidden without saving it
set hidden

" set window title
set title

" ignore case in search
set ignorecase
" unless search contains capitals
set smartcase

" show incremental effects of commands
let inccommand = 'nosplit'

let mapleader = "\<Space>"

" must be set before ALE is loaded
" let g:ale_completion_enabled = 1

" packager {{{
function! s:packager_init(packager) abort
    call a:packager.add('kristijanhusak/vim-packager', {'type': 'opt'})
    call a:packager.add('tpope/vim-sensible')
    call a:packager.add('tpope/vim-repeat')
    call a:packager.add('tpope/vim-unimpaired')
    call a:packager.add('tpope/vim-commentary')
    call a:packager.add('tpope/vim-surround')
    call a:packager.add('tpope/vim-fugitive')
    call a:packager.add('wellle/targets.vim')
    call a:packager.add('andymass/vim-matchup')
    call a:packager.add('unblevable/quick-scope')
    call a:packager.add('jeffkreeftmeijer/vim-numbertoggle')
    call a:packager.add('ntpeters/vim-better-whitespace')
    call a:packager.add('airblade/vim-rooter')
    call a:packager.add('justinmk/vim-sneak')
    call a:packager.add('simnalamburt/vim-mundo')
    call a:packager.add('airblade/vim-gitgutter')
    call a:packager.add('vimlab/split-term.vim')
    call a:packager.add('qpkorr/vim-bufkill')
    call a:packager.add('justinmk/vim-dirvish')
    call a:packager.add('junegunn/fzf.vim')
    call a:packager.add('machakann/vim-highlightedyank')
    call a:packager.add('sheerun/vim-polyglot')
    call a:packager.add('itchyny/lightline.vim')
    call a:packager.add('NLKNguyen/papercolor-theme')
    call a:packager.add('prabirshrestha/async.vim')
    call a:packager.add('prabirshrestha/vim-lsp')
    call a:packager.add('Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'})
    call a:packager.add('lighttiger2505/deoplete-vim-lsp')
    call a:packager.add('dense-analysis/ale', {'type': 'opt'})
    call a:packager.add('maximbaz/lightline-ale')
    call a:packager.add('farmergreg/vim-lastplace')
    call a:packager.add('AndrewRadev/splitjoin.vim')

    call a:packager.add('junegunn/goyo.vim')
    call a:packager.add('junegunn/limelight.vim')

    if has('nvim')
        call a:packager.add('norcalli/nvim-colorizer.lua')
    endif

    call a:packager.add('jcrd/vim-slash')
    call a:packager.add('jcrd/vim-smart-filename')
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'))
" }}}

" lsp
augroup Lsp
    autocmd!
    if executable('clangd')
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd', '-background-index']},
                    \ 'allowlist': ['c', 'cpp'],
                    \ })
    endif
    if executable('pyls')
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'pyls',
                    \ 'cmd': {server_info->['pyls']},
                    \ 'allowlist': ['python'],
                    \ 'workspace_config': {'pyls':
                    \ {'plugins':
                    \ {'pydocstyle': {'enabled': v:true}},
                    \ }}})
    endif
    if executable('bash-language-server')
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'bash-language-server',
                    \ 'cmd': {server_info->['bash-language-server', 'start']},
                    \ 'allowlist': ['sh'],
                    \ })
    endif
    if executable('go') && executable('gopls')
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'gopls',
                    \ 'cmd' : {server_info->['gopls']},
                    \ 'allowlist': ['go'],
                    \ })
        autocmd BufWritePre *.go LspDocumentFormatSync
    endif
    if executable('typescript-language-server')
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'typescript-language-server for javascript',
                    \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
                    \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
                    \ 'allowlist': ['javascript', 'javascript.jsx',
                    \ 'javascriptreact'],
                    \ })
    endif
augroup END

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup Lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 0

" deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible()? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible()? "\<c-p>" : "\<s-tab>"

function s:smart_carriage_return()
    if !pumvisible() || get(complete_info(), 'selected', -1) < 0
        return "\<CR>"
    else
        return "\<C-y>"
    endif
endfunction

inoremap <expr><CR> <SID>smart_carriage_return()

set completeopt=menu,menuone,noselect

" ale
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 50
let g:ale_fix_on_save = 1

nmap <silent> <C-j> <plug>(ale_next_wrap)
nmap <silent> <C-k> <plug>(ale_previous_wrap)

" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary
                \ guifg='#d70000' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary
                \ guifg='#f57f17' gui=underline ctermfg=81 cterm=underline
augroup END

" theme
if has('termguicolors')
    set termguicolors
endif

let g:PaperColor_Theme_Options = {
            \ 'theme': {
            \   'default.light': {
            \       'allow_italic': 1,
            \       'override': {
            \           'color00': ['#fafafa', ''],
            \ }}}}
set background=light
colorscheme PaperColor

" rooter
let g:rooter_change_directory_for_non_project_files = 'current'

set noshowmode

" lightline
let g:lightline = {'colorscheme': 'PaperColor'}

let g:lightline.component_function = {
            \ 'filename': 'SmartFilename',
            \ }

let g:lightline.component_expand = {
            \ 'linter_checking': 'lightline#ale#checking',
            \ 'linter_warnings': 'lightline#ale#warnings',
            \ 'linter_errors': 'lightline#ale#errors',
            \ 'linter_ok': 'lightline#ale#ok',
            \ }

let g:lightline.component_type = {
            \ 'linter_checking': 'left',
            \ 'linter_warnings': 'warning',
            \ 'linter_errors': 'error',
            \ 'linter_ok': 'left',
            \ }

let g:lightline.active = {
            \ 'left': [[ 'mode', 'paste' ],
            \   [ 'readonly', 'filename', 'modified' ]],
            \ 'right': [[ 'lineinfo' ], [ 'percent' ],
            \   [ 'filetype' ],
            \   [ 'linter_checking', 'linter_errors', 'linter_warnings',
            \   'linter_ok' ]]
            \ }

" fzf
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :Rg<cr>
nnoremap <leader>g "gye:exe "Rg ".@g<cr>

augroup Fzf
    autocmd FileType fzf set laststatus=0
                \ | autocmd BufLeave <buffer> set laststatus=2
augroup END

" colorizer
if has('nvim')
    nnoremap <leader>c :ColorizerToggle<cr>
endif

" highlightedyank
let g:highlightedyank_highlight_duration = 150

" sneak
let g:sneak#label = 1

" mundo
let g:mundo_prefer_python3 = 1
nnoremap <leader>u :MundoToggle<cr>

" split-term
if has('nvim')
    nnoremap <leader>t :Term<cr>
else
    nnoremap <leader>t :term<cr>
endif

" slash
noremap <plug>(slash-after) zz

" indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" netrw
" don't save history
let g:netrw_dirhistmax = 0

" enable line numbers
set number relativenumber

" dirvish
augroup Dirvish
    " disable line numbers
    autocmd FileType dirvish setlocal nonumber norelativenumber
augroup END

" terminal
if has('nvim')
    augroup Term
        " disable line numbers in terminals
        autocmd TermOpen * setlocal nonumber norelativenumber
        " start in insert mode
        autocmd TermOpen * startinsert
    augroup END
endif

function! s:goyo_enter()
    setlocal formatoptions=ant
    setlocal textwidth=80
    setlocal wrapmargin=0
    Limelight
endfunction

" goyo + limelight
augroup Goyo
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave Limelight!
augroup END

" center current line on screen with C-l
map <C-l> zz

" keybinds
nnoremap <leader>i :e $MYVIMRC<cr>
nnoremap <leader>r :so $MYVIMRC<cr>
nnoremap <leader>n :set number! relativenumber!<cr>

nnoremap <leader>e :e <C-R>=expand('%:p:h') . '/'<cr>
nnoremap <leader>s :split <C-R>=expand('%:p:h') . '/'<cr>

" buffers
noremap <A-Tab> :b#<cr>
noremap <A-n> :bn<cr>
noremap <A-p> :bp<cr>
noremap <A-q> :bd<cr>
" bufkill
let g:BufKillCreateMappings = 0
noremap <A-w> :BD<cr>

scriptencoding utf-8
set listchars=tab:▸\ ,space:·,nbsp:␣,trail:✗,eol:¬,precedes:«,extends:»
scriptencoding

nnoremap <leader>l :set list!<cr>

" vim: foldmethod=marker
