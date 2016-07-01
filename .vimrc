set confirm

set tabstop=2
set shiftwidth=2
set smarttab
set et "Expand tab
set ai "autoindent
set hlsearch
set lz "Lazy draw
set ffs=unix,dos,mac
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866

set mouse=a		" Enable mouse usage (all modes)

if has("syntax")
        syntax on
endif

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
        filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showmatch		" Show matching brackets.
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
highlight iCursor guifg=white guibg=steelblue

"colorscheme dark "Приятная цветовая схема в стиле TexMate
set nu "Отображать номер астрок

let g:fuzzy_ignore = "gems/*"

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

syntax on
colorscheme elflord

set backspace=indent,eol,start

" Bundle
execute pathogen#infect()
" Nerd tree
let g:NERDTreeWinPos = "right"
autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nmap <F7> :NERDTreeToggle<CR>

filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
iabbrev </ </<C-X><C-O>
nmap <F8> :TagbarToggle<CR>

" key mappings
noremap <C-t> :<C-U>tabnew<CR>
" CTRL-Tab is next tab
noremap <C-Tab> :<C-U>tabnext<CR>
inoremap <C-Tab> <C-\><C-N>:tabnext<CR>
cnoremap <C-Tab> <C-C>:tabnext<CR>
" " CTRL-SHIFT-Tab is previous tab
noremap <C-S-Tab> :<C-U>tabprevious<CR>
inoremap <C-S-Tab> <C-\><C-N>:tabprevious<CR>
cnoremap <C-S-Tab> <C-C>:tabprevious<CR>

function! TestToplevel() abort  
      "Eval the toplevel clojure form (a deftest) and then test-var the
      "result."
      normal! ^
      let line1 = searchpair('(','',')', 'bcrn', g:fireplace#skip)
      let line2 = searchpair('(','',')', 'rn', g:fireplace#skip)
      let expr = join(getline(line1, line2), "\n")
      let var = fireplace#session_eval(expr)
      let result = fireplace#echo_session_eval("(clojure.test/test-var " . var . ")")
      return result
    endfunction  
    au Filetype clojure nmap <c-c><c-t> :call TestToplevel()<cr>  

    au Filetype clojure nmap <c-c><c-k> :Require<cr>
