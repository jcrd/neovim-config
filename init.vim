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

" packager {{{
function! s:packager_init(packager) abort
    call a:packager.add('kristijanhusak/vim-packager', {'type': 'opt'})

    call a:packager.add('tpope/vim-sensible')
    call a:packager.add('tpope/vim-repeat')
    call a:packager.add('tpope/vim-unimpaired')
    call a:packager.add('tpope/vim-commentary')
    call a:packager.add('tpope/vim-surround')
    call a:packager.add('tpope/vim-vinegar')

    call a:packager.add('simnalamburt/vim-mundo')
    call a:packager.add('junegunn/fzf.vim')
    call a:packager.add('kana/vim-altr')
    call a:packager.add('vimlab/split-term.vim')

    call a:packager.add('ntpeters/vim-better-whitespace')
    call a:packager.add('farmergreg/vim-lastplace')

    call a:packager.add('airblade/vim-gitgutter')
    call a:packager.add('f-person/git-blame.nvim')

    call a:packager.add('itchyny/lightline.vim')
    call a:packager.add('NLKNguyen/papercolor-theme')

    call a:packager.add('jcrd/vim-slash')
    call a:packager.add('jcrd/vim-smart-filename',
                \ {'requires': ['airblade/vim-rooter', 'tpope/vim-fugitive']})
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'))
" }}}

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

let g:lightline.active = {
            \ 'left': [[ 'mode', 'paste' ],
            \   [ 'readonly', 'filename', 'modified' ]],
            \ 'right': [[ 'lineinfo' ], [ 'percent' ],
            \   [ 'filetype' ]],
            \ }

" fzf
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :Rg<cr>
nnoremap <leader>g "gye:exe "Rg ".@g<cr>

augroup Fzf
    autocmd FileType fzf set laststatus=0
                \ | autocmd BufLeave <buffer> set laststatus=2
augroup END

" altr
nmap <leader>a <plug>(altr-forward)
nmap <leader>A <plug>(altr-back)

" git-blame
let g:gitblame_enabled = 0
nmap <leader>m :GitBlameToggle<cr>

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
" hide dotfiles by default, toggle with `gh`
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" enable line numbers
set number relativenumber

" highlight yanked text
au TextYankPost * silent! lua vim.highlight.on_yank()

" terminal
if has('nvim')
    augroup Term
        " disable line numbers in terminals
        autocmd TermOpen * setlocal nonumber norelativenumber
        " start in insert mode
        autocmd TermOpen * startinsert
    augroup END
endif

" center current line on screen with C-l
map <C-l> zz

" keybinds
nnoremap <leader>i :e $MYVIMRC<cr>
nnoremap <leader>r :so $MYVIMRC<cr>
nnoremap <leader>n :set number! relativenumber!<cr>

nnoremap <leader>e :e <C-R>=expand('%:p:h') . '/'<cr>
nnoremap <leader>s :split <C-R>=expand('%:p:h') . '/'<cr>

nnoremap <leader>x :Explore<cr>

" buffers
noremap <A-Tab> :b#<cr>

scriptencoding utf-8
set listchars=tab:▸\ ,space:·,nbsp:␣,trail:✗,eol:¬,precedes:«,extends:»
scriptencoding

nnoremap <leader>l :set list!<cr>

" vim: foldmethod=marker
