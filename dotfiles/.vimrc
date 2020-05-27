"this is a comment
"type :help command to see the vim help docs for that command
" navigating folds
"  zM - shortcut to close all folds from normal mode
"  zR - shortcut to open all folds from normal mode
"  zc - Close the current fold while cursor is inside of fold from normal mode
"  l - Open a fold which is under the cursor.
"  h - Open a fold which is under the cursor.

"this should be first always according to help docs if going to set it
set nocompatible

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPTIONS FOR ALL FILES UNLESS OVERRIDDEN BY FILETYPE {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""

"if the number of colors supported by terminal is > 1 enable syntax highlighting
if &t_Co > 1
  syntax enable
endif
"enable filetype detection
:filetype on
"number of spaces to shift when using >> or << command in normal mode
set shiftwidth=2
"showmode indicates input or replace mode at bottom
set showmode
"showmatch briefly jumps to the line as you search
set showmatch
"when backspacing will backspace over eol, autoindent, and start
set backspace=2
"hlsearch for when there is a previous search pattern, highlight all its matches.
set hlsearch
"ruler shows line and char number in bottom right of vim
set ruler
"each line has line number prepended
set number
"scrolloff which keeps screen lines above and below the cursor when scrolling
set so=7
"expandtab means tabs create spaces in insert mode, softtabstop is the number of spaces created
"tabstop affects visual representation of tabs only
set tabstop=8
set expandtab
set softtabstop=2
set incsearch
"always show status bar at bottom
set laststatus=2
"always show tab bar at the top
"set showtabline=2
"ignore case sensitivity
set ignorecase
"Modify vim terminal colors based on the terminal background being light or dark
"set background=light
set background=dark
"when pressing ENTER will automatically indent the line
set autoindent

"filebrowser settings
let g:netrw_liststyle=3

"""""""""""""""""""""""""""""
" FUNCTION KEY SHORTCUTS {{{1
"""""""""""""""""""""""""""""

" F2 key - Toggle paste or nopaste
" F3 key - Toggle scrollbinding to scroll multiple windows in tandem
" F4 key - Toggle highlighting lines longer than 80 chars

"shortcut for toggling paste while in insert mode, press F2 key
set pastetoggle=<f2>
"shortcut for toggling scrollbinding; press F3 key
nnoremap <F3> :set scb! scb?<CR>
"toggle highlight lines longer than 80 chars in red; press F4 key
nnoremap <F4> :call ToggleErrorWidth()<CR>

"""""""""""""""""""""""""""""
" FUNCTIONS {{{1
"""""""""""""""""""""""""""""

func ToggleErrorWidth()
  :hi ColorColumn ctermbg=black guibg=black
  :set colorcolumn=81
  if exists('w:errorwidth')
    call matchdelete(w:errorwidth)
    unlet w:errorwidth
  else
    let w:errorwidth=matchadd('ErrorMsg', '\%>80v.\+', -1)
  endif
endfunc

"""""""""""""""""""""""""""""
" AUTOCMD FILE LOGIC BEHAVIOR {{{1
"""""""""""""""""""""""""""""

" These are custom settings depending on which filetype is opened.  For
" instance, vim can behave diferently when it has a Java file open vs a shell
" script.
"
" To detect the filetype of your currenlty opened file then type the following:
"    :set filetype?
"
" Then create a setting which applies only to that filetype.

" automatically fold comments in .vimrc file
:autocmd BufNewFile,BufRead .vimrc setlocal foldmethod=marker foldexpr=0
"jenkins plugins are just zip files; see also :help zip
:autocmd BufReadCmd *.jpi,*.hpi call zip#Browse(expand("<amatch>"))
:autocmd BufNewFile,BufRead .gitconfig_settings setlocal filetype=gitconfig
:autocmd BufNewFile,BufRead *.gradle,Jenkinsfile setlocal filetype=groovy expandtab
:autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
:autocmd BufNewFile,BufRead TODO setlocal filetype=markdown
:autocmd BufNewFile,BufRead *.jelly setlocal filetype=xml
"cfengine promises files
:autocmd BufNewFile,BufRead *.cf setlocal filetype=conf
"Set options in a specific way based on what type of file is opened
:autocmd FileType java,xml,python,markdown,make,gitconfig,groovy,cpp,go setlocal shiftwidth=4 tabstop=4 softtabstop=4
:autocmd FileType groovy setlocal expandtab
:autocmd FileType c,cpp,java,groovy setlocal cindent
"indent with tabs when following FileTypes are opened
:autocmd FileType make,gitconfig setlocal noexpandtab
"auto newline at 80 characters as you type and auto-format formatoptions+=a or fo+=a
"autoformatting can also be accomplished with gq see :help gq
:autocmd FileType markdown setlocal textwidth=80
"auto newline at 73 chars as you type. git commit messages are 73 chars wide on GitHub
:autocmd FileType gitcommit setlocal textwidth=73
"will highlight trailing white space with grey
:highlight ExtraWhitespace ctermfg=Grey ctermbg=LightGrey
:autocmd ColorScheme * highlight ExtraWhitespace ctermfg=Grey ctermbg=LightGrey
:autocmd BufWinEnter * let w:extrawhite=matchadd('ExtraWhitespace', '\s\+\%#\@<!$', -1)
"highlight lines longer than 80 chars in red
:autocmd BufWinEnter *.md,*.sh call ToggleErrorWidth()

""""""""""""""""
" CHARACTER MAPS {{{1
""""""""""""""""

":w!! will ask for password when trying to write to system files
"useful if you open a file as a user but need sudo to write to it as root
cmap w!! %!sudo tee > /dev/null %

" load pathogen only if it exists
" Sometimes I use pathogen... sometimes I don't.
" https://github.com/tpope/vim-pathogen
" https://github.com/rodjek/vim-puppet
" https://github.com/pearofducks/ansible-vim
" https://github.com/Xuyuanp/nerdtree-git-plugin
if filereadable(expand("~/.vim/autoload/pathogen.vim"))
    execute pathogen#infect()
    filetype plugin indent on
endif
