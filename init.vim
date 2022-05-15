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

" enable mouse
set mouse=a

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
let g:lightline = { 'colorscheme': 'PaperColor' }

set background=light
colorscheme PaperColor

set noshowmode

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
