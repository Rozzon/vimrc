set nocompatible              " be iMproved, required
filetype off                  " required

colorscheme desert
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'preservim/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'yegappan/taglist' 

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

let mapleader=","

" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" nerdtree change the default arrows
" let g:NERDTreeDirArrowExpandable = '?'
" let g:NERDTreeDirArrowCollapsible = '?'

" nerdtree show lines of files, enable NERDTreeFileLines will stuck a little time
" let g:NERDTreeFileLines = 1

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

" common set
set colorcolumn=120
set ts=4
set expandtab
set shiftwidth=4
set autoindent
set ignorecase

" Enable line and column number persistence
set viminfo='100,<1000,s100,h

" Automatically jump to the last cursor position when opening a file
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif


autocmd FileType c syntax enable

" cscope shortcut
noremap <leader>cs :cs find s
noremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
noremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
noremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
noremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
noremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
noremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
noremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
noremap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>

" update cscope index
map <f12> : call ReConnectCscope()<cr>
func! ReConnectCscope()
    exec "cs kill 0"
    exec "!./generate.sh"
    exec "cs add cscope.out"
endfunc

set cscopequickfix=c-,d-,e-,g-,i-,s-,t-
nmap <C-n> :cnext<CR>
nmap <C-p> :cprev<CR>

" Define a function to switch between .c and .h files
function! SwitchCHeader()
  let current_file = expand('%')
  if current_file =~ '\.c$'
    " If the current file is a .c file, switch to the corresponding .h file
    let header_file = substitute(current_file, '\.c$', '.h', '')
  elseif current_file =~ '\.h$'
    " If the current file is a .h file, switch to the corresponding .c file
    let header_file = substitute(current_file, '\.h$', '.c', '')
  else
    " If it's not .c or .h, do nothing
    return
  endif

  " Open the corresponding .c or .h file
  execute 'edit' header_file
endfunction

" Map <Leader>f to call the function
nnoremap <Leader>f :call SwitchCHeader()<CR>

" To configure the charater used for spaces
set nolist
set listchars=space:·,tab:^I,eol:$
" Toggle display of space characters
nnoremap <Leader>l :set list!<CR>

" To remove trailing white spaces from each line
nnoremap <leader>k :%s/\s\+$//g<CR>

" To enable or disable line number
set nu
set relativenumber

" Define a custom highlight group for the cursor word
" highlight CursorWord ctermbg=lightblue guibg=lightblue
" autocmd CursorMoved * exe printf('match CursorWord /\<%s\>/', expand('<cword>'))

" enable highlight search
set hlsearch
" highlights the current line
"set cursorline
" highlight the current column
set cursorcolumn

"nnoremap <F5> :match StatusLineTerm /<C-R><C-W>/<CR>
"nnoremap <F6> :match StatusLineTerm /\<\C-R\><\C-W>\>/\<CR\>
nnoremap <F5> :execute 'match StatusLineTerm /\V\<'.escape(expand('<cword>'), '/\').'\>/'<CR>

" ==========================================================================
" ctrlp plugin settings
let g:ctrlp_map = '<c-k>'
let g:ctrlp_cmd = 'CtrlP>'
" when invoked, unless a starting directory is specified, CtrlP will set its
" local working directory according to this variable:
" 'r' - the nearest ancestor that contains one of these directories or files:
"   .git .hg .svn .bzr _darcs
let g:ctrlp_working_path_mode = 'ra'
" Exclude files and directories using Vim's wildignore and CtrlP's own g:ctrlp_custom_ignore:
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

nnoremap <leader>p :echo expand('%:p')<CR>
nnoremap <S-k> :resize -1<CR>             
nnoremap <S-j> :resize +1<CR>             
nnoremap <S-l> :vertical resize -1<CR>    
nnoremap <S-h> :vertical resize +1<CR>    

let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口
