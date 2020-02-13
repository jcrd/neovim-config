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
function! PackagerInit() abort
    packadd vim-packager
    call packager#init()
    call packager#add('kristijanhusak/vim-packager', {'type': 'opt'})
    call packager#add('tpope/vim-sensible')
    call packager#add('tpope/vim-repeat')
    call packager#add('tpope/vim-unimpaired')
    call packager#add('tpope/vim-commentary')
    call packager#add('tpope/vim-surround')
    call packager#add('tpope/vim-fugitive')
    call packager#add('wellle/targets.vim')
    call packager#add('andymass/vim-matchup')
    call packager#add('jeffkreeftmeijer/vim-numbertoggle')
    call packager#add('ntpeters/vim-better-whitespace')
    call packager#add('airblade/vim-rooter')
    call packager#add('justinmk/vim-sneak')
    call packager#add('simnalamburt/vim-mundo')
    call packager#add('Yilin-Yang/vim-markbar')
    call packager#add('airblade/vim-gitgutter')
    call packager#add('vimlab/split-term.vim')
    call packager#add('qpkorr/vim-bufkill')
    call packager#add('justinmk/vim-dirvish')
    call packager#add('junegunn/fzf.vim')
    call packager#add('machakann/vim-highlightedyank')
    call packager#add('sheerun/vim-polyglot')
    call packager#add('itchyny/lightline.vim')
    call packager#add('NLKNguyen/papercolor-theme')
    call packager#add('prabirshrestha/async.vim')
    call packager#add('prabirshrestha/vim-lsp', {'type': 'opt'})
    call packager#add('dense-analysis/ale', {'type': 'opt'})
    call packager#add('maximbaz/lightline-ale')
    call packager#add('farmergreg/vim-lastplace')
    call packager#add('jpalardy/vim-slime')

    if has('nvim')
        call packager#add('norcalli/nvim-colorizer.lua')
    endif

    call packager#add('jcrd/vim-slash')
endfunction

command! PackagerInstall call PackagerInit() | call packager#install()
command! -bang PackagerUpdate call PackagerInit()
            \ | call packager#update({'force_hooks': '<bang>'})
command! PackagerClean call PackagerInit() | call packager#clean()
command! PackagerStatus call PackagerInit() | call packager#status()
" }}}

" lsp
augroup Lsp
    autocmd!
    if executable('clangd')
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp'],
                    \ })
    endif
    if executable('gopls')
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'gopls',
                    \ 'cmd' : {server_info->['gopls']},
                    \ 'whitelist': ['go'],
                    \ })
    endif
augroup END

let g:lsp_diagnostics_enabled = 0

" ale
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 50

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

" include project root and git branch in filename
" requires vim-rooter and vim-fugitive
function! LightlineFilename()
    let fname = expand('%:p')
    if fname !=# ''
        let root = FindRootDirectory()
        if root !=# '' && fname =~# '^' . root
            let head = fugitive#head()
            let branch = head !=# '' ? ':' . head : ''
            let project = '[' . fnamemodify(root, ':t') . branch . ']'
            let fname = substitute(fname, root, project, '')
        else
            " shorten $HOME to ~
            if fname =~# '^' . $HOME
                let fname = substitute(fname, $HOME, '~', '')
            endif
        endif
        " convert to floating point with * 1.0
        if strlen(fname) * 1.0 / winwidth(0) > 0.33
            let path = split(fname, '/')
            let spath = [path[0]]
            for p in path[1:-2]
                let spath += [strpart(p, 0, p[0] ==# '.' ? 2 : 1)]
            endfor
            let fname = join(spath, '/') . '/' . path[-1]
        endif
    else
        let fname = '[No Name]'
    endif
    return fname
endfunction

let g:lightline = {'colorscheme': 'PaperColor'}

let g:lightline.component_function = {
            \ 'filename': 'LightlineFilename',
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

" slime
let g:slime_target = 'neovim'
let g:slime_dont_ask_default = 1

" fzf
nnoremap <leader>b :Buffers<cr>

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

" enable omni completion
set omnifunc=syntaxcomplete#Complete
" recommended by ALE (see :help ale-completion)
set completeopt=menu,menuone,preview,noselect,noinsert

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
