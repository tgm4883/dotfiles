runtime! archlinux.vim

" .vimrc is no longer use due to switch to neovim,
" check `~/.config/nvim/init.vim` instead

let mapleader = "\<Space>"

set clipboard=unnamedplus
set hlsearch
set smartcase
set relativenumber
set number

filetype plugin indent on
" show existing tab with 2 spaces width
set tabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
" On pressing tab, insert 2 spaces
set expandtab


syntax on


