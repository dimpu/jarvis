source ~/.config/nvim/plugins.vim

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Remap leader key to ,
let mapleader=","

" Line Numbers
set nu

" Yank and paste with the system clipboard
set clipboard=unnamed

" Hides buffers instead of closing them
set hidden

" === TAB/Space settings === "
" Insert spaces when TAB is pressed.
set expandtab

" Render TAB's using this many spaces.
set tabstop=2

" Indentation amount for < and > commands.
set shiftwidth=2

" do not wrap long lines by default
set nowrap

" Hightlight trailing whitespace
highlight Trail ctermbg=red guibg=red
call matchadd('Trail', '\s\+$', 100)

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Customize highlighted option group
" call denite#custom#option('default', 'highlight_mode_insert', 'TermCursor')

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize   - Auto resize the Denite window height automatically.
"   prompt        - Customize denite prompt
"   direction     - Specify Denite window direction as directly below current pane
"   winminheight  - Specify min height for Denite window
let s:denite_options = {'default' : {
\ 'auto_resize': 1,
\ 'prompt': '❯',
\ 'direction': 'rightbelow',
\ 'winminheight': '10'
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for fname in keys(a:opts)
	  for dopt in keys(a:opts[fname])
		  call denite#custom#option(fname, dopt, a:opts[fname][dopt])
	  endfor
  endfor
endfunction

call s:profile(s:denite_options)

" === NERDTree === "
" Show hidden files/directories
let NERDTreeShowHidden=1

" Custom icons for expandable/expanded directories
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'

" === Ale === "
" Enable language-specif linters
let g:ale_linters = {
\ 'vim' : ['vint'],
\ 'javascript' : ['jshint']
\ }

" Customize warning/error signs
let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'

" Custom error format
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Don't lint on text change, only on save
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1

" === Vim airline ==== "
" Custom setup that removes filetype/whitespace from default vim airline bar
let g:airline#extensions#default#layout = [[ 'a', 'b', 'c'], ['z', 'warning', 'error']]

" Update section b to only have git branch
let g:airline_section_b = airline#section#create_left(['branch'])

" Update section z to just have linenumber:column number
let g:airline_section_z = airline#section#create(['linenr',':%3v'])

" Keep list of open files in buffer at top
let g:airline#extensions#tabline#enabled = 1

" Smartly uniquify buffers names with similar filename, suppressing common parts of paths.
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Set minimum required files to show the tabline
let g:airline#extensions#tabline#buffer_min_count = 2

" Make font white for readability in warning/error section
" TODO: Report this bug with ocean colorscheme
call airline#parts#define_accent('error', 'white')

" === vim-javascript === "
" Enable syntax highlighting for JSDoc
let g:javascript_plugin_jsdoc = 1

" === vim-jsx === "
" Highlight jsx syntax even in non .jsx files
let g:jsx_ext_required = 0

" ============================================================================ "
" ===                                UI                                    === "
" ============================================================================ "

" Enable true color support
set termguicolors

" Editor theme
set background=dark
colorscheme OceanicNext

" Vim airline theme
let g:airline_theme='base16_oceanicnext'
let g:airline_solarized_bg='dark'

" Make end of buffer char (~) less noticeable
hi! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg

" Better higlighting of matched search lines
call denite#custom#option('default', 'highlight_mode_insert', 'WildMenu')

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" === Denite shorcuts === "
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term
"   <leader>d - Delete item under cursor (useful for delete buffers in normal mode)
"
nmap ; :Denite buffer<CR>
nmap <leader>t :Denite file_rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -mode=normal<CR>
call denite#custom#map('normal', '<leader>d', '<denite:do_action:delete>')

" === Nerdtree shorcuts === "
"  <leader>n - Toggle NERDTree on/off
"  <leader>f - Opens current file location in NERDTree
"
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

"   <Space> - PageDown
"   -       - PageUp
noremap <Space> <PageDown>
noremap - <PageUp>

" === vim-better-whitespace === "
"   <leader>y - Automatically remove trailing whitespace
"
nmap <leader>y :StripWhitespace<CR>

" === Search shorcuts === "
"   <leader>h - Find and replace
"   <leader>/ - Claer highlighted search terms while preserving history
"
map <leader>h :%s///<left><left>
nmap <silent> <leader>/ :nohlsearch<CR>

" === Easy-motion shortcuts ==="
"   <leader>w - Easy-motion highlights first word letters bi-directionally
"
map <leader>w <Plug>(easymotion-bd-w)

" ============================================================================ "
" ===                                 MISC.                                === "
" ============================================================================ "

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %

" === Search === "
" ignore case when searching
set ignorecase

" if the search string has an upper case letter in it, the search will be case sensitive
set smartcase

" Set backups
if has('persistent_undo')
  set undodir=~/.vim/tmp/undo//
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
set backup
set noswapfile

