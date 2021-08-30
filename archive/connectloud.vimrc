""set backspace=indent,eol,start " allow backspacing over everything in insert mode
set backup                     " keep a backup file
set backupdir=~/vim_backups    " custom backup directory
set history=999                " keep 100 lines of command line history
"set ruler                     " show the cursor position all the time
"set showcmd                   " display incomplete commands
set mouse=a                    " enable the mouse
"set showmode                  " so you know what mode you are in
"set laststatus=2              " always put a status line in.
"set scrolloff=10              " start scrolling 10 lines from the top/bottom
"set ch=2                      " set command line 2 lines high
"set nowrap                    " no line wrapping 
set ignorecase                 " case insensitive search
"set showmatch                  " show matching parenthesis
set wildmenu                   " enable enhanced command line completion
set wildignore+=*.pui,*.prj    " ignore these when completing file or directory names
set ttyfast                    " faster terminal updates

syntax on                      " enable syntax highlighting
filetype plugin indent on      " enable file type detection

set showcmd		       " Show partial commands in the last line of the screen
set smartcase
"set autoindent		       " Keep the same indent as the line you're currently on. Useful for READMEs, etc.
set nostartofline	       " Stop certain movements from always going to the first character of a line.
set tabstop=4		       "Sets how many spaces a tab takes up"
set shiftwidth=4	       "Sets how many spaces auto indent does"

map <Tab> 		:s/^/	/ggv
map <S-Tab> 		i	gv
map <S-Right>OC 	$
map <S-Left>OD 	0
map <S-Down>OB 	G
map <S-Up>OA 		gg
map cws 		:s/^\s*//g
map cp			:s-^-#-g
map cj			:s-^-//-g
map cr			:s-^//\+--gegv:s-^#\+--ge
map !			@:
