" Vim-Plug plugin manager
call plug#begin('~/.config/nvim/plugged')

" Essential Rust plugins
Plug 'rust-lang/rust.vim'                    " Official Rust plugin
Plug 'dense-analysis/ale'                    " Async Lint Engine (simpler than LSP)

" Additional useful plugins
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Better syntax highlighting
Plug 'nvim-telescope/telescope.nvim'         " Fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'} " Better performance
Plug 'nvim-lua/plenary.nvim'                 " Required by telescope
Plug 'nvim-tree/nvim-tree.lua'               " Modern file explorer
Plug 'nvim-tree/nvim-web-devicons'           " File icons for nvim-tree
Plug 'vim-airline/vim-airline'               " Status line
Plug 'vim-airline/vim-airline-themes'        " Status line themes
Plug 'tpope/vim-fugitive'                    " Git integration
Plug 'airblade/vim-gitgutter'                " Git diff markers
Plug 'scrooloose/nerdcommenter'              " Easy commenting
Plug 'jiangmiao/auto-pairs'                  " Auto close brackets
Plug 'coder/claudecode.nvim'                 " Claude Code in Neovim
Plug 'folke/snacks.nvim'                     " Required for claudecode.nvim

" Light colorschemes
Plug 'morhetz/gruvbox'                       " Popular color scheme
Plug 'NLKNguyen/papercolor-theme'            " Clean light theme
Plug 'sainnhe/everforest'                    " Comfortable green theme
Plug 'catppuccin/nvim', { 'as': 'catppuccin' } " Modern theme with light variant

" Additional vibrant colorschemes for better Rust highlighting
Plug 'folke/tokyonight.nvim'                 " Has excellent light variants too
Plug 'rebelot/kanagawa.nvim'                 " Has a beautiful light variant (lotus)
Plug 'EdenEast/nightfox.nvim'                " Includes dayfox and dawnfox light themes
Plug 'rose-pine/neovim', { 'as': 'rose-pine' } " Beautiful light variant (dawn)
Plug 'projekt0n/github-nvim-theme'           " GitHub's official light theme

call plug#end()

" Auto-install missing plugins on startup
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Leader key
let mapleader = " "             " Set space as leader key

" Basic settings
set number                      " Show line numbers
set relativenumber              " Relative line numbers
set expandtab                   " Use spaces instead of tabs
set shiftwidth=4                " Indent by 4 spaces
set tabstop=4                   " Tab width is 4 spaces
set smartindent                 " Smart indentation
set autoindent                  " Auto indentation
set cursorline                  " Highlight current line
set mouse=a                     " Enable mouse support
set clipboard=unnamedplus       " Use system clipboard
set termguicolors               " Enable true colors
set signcolumn=yes              " Always show sign column
set updatetime=300              " Faster completion
set cmdheight=2                 " More space for messages
set hidden                      " Allow hidden buffers
set completeopt=menu,menuone,noselect " Better completion experience
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uppercase present
set wildignorecase              " Case insensitive command completion

" Folding settings
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99           " Start with all folds open
set foldnestmax=10              " Maximum fold nesting

" Color scheme configuration
set background=light
" Try multiple light themes in order of preference
silent! colorscheme PaperColor
if !exists('g:colors_name') || g:colors_name != 'PaperColor'
  silent! colorscheme everforest
  if !exists('g:colors_name') || g:colors_name != 'everforest'
    silent! colorscheme catppuccin-latte
    if !exists('g:colors_name') || g:colors_name != 'catppuccin-latte'
      silent! colorscheme gruvbox
    endif
  endif
endif

" PaperColor specific settings
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 0,
  \       'allow_bold': 1,
  \       'allow_italic': 1
  \     }
  \   }
  \ }

" Everforest settings
let g:everforest_background = 'soft'
let g:everforest_better_performance = 1
let g:everforest_enable_italic = 1

" Rust specific settings
let g:rustfmt_autosave = 1                   " Format on save
let g:rust_clip_command = 'xclip -selection clipboard'

" Enhanced semantic highlighting for Rust
let g:rust_keep_autopairs_default = 1
let g:rust_recommended_style = 1
let g:rust_fold = 1

" ALE Configuration 
let g:ale_linters = {
\   'rust': ['cargo', 'analyzer'],
\}
let g:ale_fixers = {
\   'rust': ['rustfmt'],
\}
let g:ale_fix_on_save = 1                    " Auto-format on save
let g:ale_completion_enabled = 0             " Disable ALE completion (causes issues)
let g:ale_rust_cargo_use_check = 1
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_check_all_targets = 1
let g:ale_rust_cargo_default_feature_behavior = 'all'
let g:ale_rust_cargo_include_features = 1
let g:ale_rust_analyzer_executable = 'rust-analyzer'
let g:ale_rust_analyzer_config = {
\   'rust-analyzer': {
\     'files': {
\       'excludeDirs': ['**/.cargo/**', '**/.rustup/**', '**/target/**', '**/.git/**'],
\     },
\     'workspace': {
\       'symbol': {
\         'search': {
\           'scope': 'workspace'
\         }
\       }
\     },
\     'linkedProjects': [getcwd() . '/Cargo.toml'],
\     'cargo': {
\       'allFeatures': v:true,
\     },
\   }
\ }

" ALE floating window settings
let g:ale_floating_preview = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_detail_to_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']

" rust-analyzer loading indicator
let g:rust_analyzer_loading = 1
function! RustAnalyzerStatus()
  if &filetype == 'rust'
    if g:rust_analyzer_loading
      return ' 🔄 rust-analyzer loading...'
    else
      return ' ✅ rust-analyzer ready'
    endif
  endif
  return ''
endfunction

" Auto-update status when rust-analyzer is ready
augroup RustAnalyzerStatus
  autocmd!
  autocmd BufEnter *.rs call timer_start(1000, 'CheckRustAnalyzer', {'repeat': -1})
augroup END

function! CheckRustAnalyzer(timer)
  if &filetype != 'rust' || !g:rust_analyzer_loading
    call timer_stop(a:timer)
    return
  endif
  
  " Find a good word to test on - look for function names, types, etc.
  let l:pos_before = getpos('.')
  let l:file_before = expand('%:p')
  let l:test_successful = 0
  
  " Save current search
  let l:old_search = @/
  
  try
    " Look for common Rust patterns to test on
    let l:patterns = ['fn \w\+', '\w\+::', 'let \w\+', 'struct \w\+', 'enum \w\+']
    
    for l:pattern in l:patterns
      " Search for pattern in current buffer
      if search(l:pattern, 'nw') > 0
        " Move to the pattern
        call search(l:pattern, 'w')
        " Position cursor on the word part
        normal! w
        
        " Test go-to-definition
        silent! ALEGoToDefinition
        
        let l:pos_after = getpos('.')
        let l:file_after = expand('%:p')
        
        " If we jumped somewhere meaningful, rust-analyzer is working
        if l:file_after != l:file_before || 
           \ abs(l:pos_after[1] - l:pos_before[1]) > 5
          let g:rust_analyzer_loading = 0
          let l:test_successful = 1
          echo 'rust-analyzer is now ready!'
          call timer_stop(a:timer)
          break
        endif
        
        " Restore position for next test
        call setpos('.', l:pos_before)
        if l:file_after != l:file_before
          execute 'buffer ' . bufnr(l:file_before)
        endif
      endif
    endfor
    
  catch
    " Search failed, still loading
  finally
    " Always restore original position and search
    call setpos('.', l:pos_before)
    if expand('%:p') != l:file_before
      execute 'buffer ' . bufnr(l:file_before)
    endif
    let @/ = l:old_search
  endtry
endfunction

" Navigation keybindings (ALE)
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gr :ALEFindReferences<CR>
nnoremap <silent> K :ALEHover<CR>
nnoremap <silent> <leader>rn :ALERename<CR>

" ALE commands (manual debugging)
nnoremap <leader>al :ALELint<CR>
nnoremap <leader>ai :ALEInfo<CR>
nnoremap <leader>ad :ALEDetail<CR>
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>

" Simple keybindings for testing
nnoremap <F2> :ALEInfo<CR>
nnoremap <F3> :ALEDetail<CR>
nnoremap <F4> :ALELint<CR>

" Manual commands for rust-analyzer status
command! RustAnalyzerReset let g:rust_analyzer_loading = 1
command! RustAnalyzerReady let g:rust_analyzer_loading = 0 | echo 'Marked rust-analyzer as ready'
command! RustAnalyzerDebug call <SID>debug_rust_analyzer()

function! s:debug_rust_analyzer()
  echo 'rust-analyzer status: ' . (g:rust_analyzer_loading ? 'loading' : 'ready')
  echo 'Current word: ' . expand('<cword>')
  
  " Test hover
  try
    redir => l:hover_output
    silent! ALEHover  
    redir END
    echo 'Hover output: ' . substitute(l:hover_output, '\n', ' | ', 'g')
  catch
    echo 'Hover failed'
  endtry
  
  " Test ALE info
  let l:buffer_info = get(g:ale_buffer_info, bufnr(''), {})
  let l:loclist = get(l:buffer_info, 'loclist', [])
  echo 'Diagnostics count: ' . len(l:loclist)
  for l:item in l:loclist
    echo 'Linter: ' . get(l:item, 'linter_name', 'unknown')
  endfor
endfunction

" Simple documentation lookup
function! s:show_documentation()
  let l:word = expand('<cword>')
  execute 'help ' . l:word
  if v:shell_error
    echom 'No documentation found for: ' . l:word
  endif
endfunction

" ALE appearance and behavior
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'
let g:ale_sign_style_error = '✗'
let g:ale_sign_style_warning = '⚠'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1

" Airline configuration
let g:airline_theme = 'papercolor'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
function! AirlineRustAnalyzer()
  return RustAnalyzerStatus()
endfunction
call airline#parts#define_function('rust_analyzer', 'AirlineRustAnalyzer')
let g:airline_section_x = '%{AirlineRustAnalyzer()}%{airline#util#prepend(airline#parts#filetype(),0)}'

" Completion with Tab
inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab>
  \ pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR>
  \ pumvisible() ? "\<C-y>" : "\<CR>"

" nvim-tree keybindings
nnoremap <leader>nt :NvimTreeToggle<CR>
nnoremap <leader>nf :NvimTreeFindFile<CR>
nnoremap <leader>nc :NvimTreeCollapse<CR>

" Telescope keybindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').grep_string({search = vim.fn.input('Search: ')})<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>

" Alternative grep commands (working fallbacks)
nnoremap <leader>rg :Rg<Space>
nnoremap <leader>R :RgInteractive<CR>

" Debug telescope command
command! TelescopeDebug lua print('rg test:'); print(vim.fn.system('rg --version')); print('Telescope config:'); print(vim.inspect(require('telescope.config').values.vimgrep_arguments))
command! TelescopeTest lua require('telescope.builtin').live_grep({prompt_title = 'Test Live Grep'})
command! RgTest lua print('Direct rg test:'); print(vim.fn.system('rg --color=never --no-heading --with-filename --line-number --column fn src/main.rs'))
command! -nargs=1 Rg lua vim.fn.setqflist({}); vim.fn.setqflist(vim.fn.systemlist('rg --vimgrep ' .. vim.fn.shellescape(<q-args>)), 'r'); vim.cmd('copen')
command! RgInteractive lua vim.ui.input({prompt = 'Search: '}, function(input) if input then vim.cmd('Rg ' .. input) end end)

" Alternative working live grep using Telescope grep_string
command! -nargs=1 Tgrep lua require('telescope.builtin').grep_string({search = <q-args>})
nnoremap <leader>gs :Tgrep<Space>

" Colorscheme switching
nnoremap <leader>c1 :set background=light<CR>:colorscheme PaperColor<CR>
nnoremap <leader>c2 :set background=light<CR>:colorscheme everforest<CR>
nnoremap <leader>c3 :set background=light<CR>:colorscheme catppuccin-latte<CR>
nnoremap <leader>c4 :set background=light<CR>:colorscheme gruvbox<CR>
nnoremap <leader>cd :set background=dark<CR>:colorscheme gruvbox<CR>

" Vibrant light themes for better Rust syntax highlighting
nnoremap <leader>cl1 :set background=light<CR>:colorscheme tokyonight-day<CR>
nnoremap <leader>cl2 :set background=light<CR>:colorscheme kanagawa-lotus<CR>
nnoremap <leader>cl3 :set background=light<CR>:colorscheme dayfox<CR>
nnoremap <leader>cl4 :set background=light<CR>:colorscheme dawnfox<CR>
nnoremap <leader>cl5 :set background=light<CR>:colorscheme rose-pine-dawn<CR>
nnoremap <leader>cl6 :set background=light<CR>:colorscheme github_light<CR>
nnoremap <leader>cl7 :set background=light<CR>:colorscheme github_light_high_contrast<CR>

" Dark themes (if you want to try them)
nnoremap <leader>cd1 :set background=dark<CR>:colorscheme tokyonight-storm<CR>
nnoremap <leader>cd2 :set background=dark<CR>:colorscheme kanagawa-wave<CR>
nnoremap <leader>cd3 :set background=dark<CR>:colorscheme catppuccin-mocha<CR>

" Reload config
nnoremap <leader>rc :source ~/.config/nvim/init.vim<CR>:echo "Config reloaded"<CR>

" ClaudeCode keybindings
nnoremap <leader>ac :ClaudeCode<CR>
nnoremap <leader>af :ClaudeCodeFocus<CR>
nnoremap <leader>ar :ClaudeCode --resume<CR>
nnoremap <leader>aC :ClaudeCode --continue<CR>
nnoremap <leader>am :ClaudeCodeSelectModel<CR>
nnoremap <leader>ab :ClaudeCodeAdd %<CR>
vnoremap <leader>as :ClaudeCodeSend<CR>
nnoremap <leader>aa :ClaudeCodeDiffAccept<CR>
nnoremap <leader>ad :ClaudeCodeDiffDeny<CR>

" Terminal mode window navigation
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>l <C-\><C-n><C-w>l
tnoremap <C-h> <C-\><C-n><C-w>h

" Double Ctrl-c to switch to Claude from editor
nnoremap <C-c><C-c> <cmd>wincmd l<CR>
inoremap <C-c><C-c> <Esc><cmd>wincmd l<CR>



" Lua configuration
lua << EOF
-- Treesitter configuration
local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if status_ok then
  configs.setup {
    ensure_installed = { "rust", "toml", "lua", "vim", "markdown", "markdown_inline" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      -- Enable enhanced highlighting for Rust
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    },
    indent = {
      enable = true,
    },
    fold = {
      enable = true,
    },
    -- Enable rainbow parentheses for better bracket matching
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 1000,
    },
    -- Enable incremental selection for better code navigation
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  }
end

-- Telescope configuration (minimal to fix live_grep)
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
  telescope.setup({
    defaults = {
      -- Use default ripgrep arguments (don't override)
      file_ignore_patterns = {
        ".git/",
        ".cargo/",
        ".rustup/", 
        "target/",
      },
    },
  })
  
  -- Load fzf extension
  pcall(telescope.load_extension, 'fzf')
end

-- nvim-tree configuration
local tree_ok, nvim_tree = pcall(require, "nvim-tree")
if tree_ok then
  -- Disable netrw (recommended by nvim-tree)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  
  nvim_tree.setup({
    sort_by = "case_sensitive",
    view = {
      width = 30,
      side = "left",
    },
    renderer = {
      group_empty = true,
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
    filters = {
      dotfiles = false,
      custom = { "^.git$", "^.cargo$", "^.rustup$", "^target$" },
    },
    git = {
      enable = true,
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = false,
        resize_window = true,
      },
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
  })
end

-- ClaudeCode configuration
local claudecode_ok, claudecode = pcall(require, "claudecode")
if claudecode_ok then
  claudecode.setup({
    -- Use local installation if available, otherwise global
    terminal_cmd = vim.fn.filereadable(vim.fn.expand("~/.claude/local/claude")) == 1 
      and "~/.claude/local/claude" 
      or "claude",
    terminal = {
      snacks_win_opts = {
        position = "right",
        width = 0.5,
        keys = {
          -- Override q to not close but switch instead
          q = {
            "q",
            function()
              vim.cmd("wincmd h")  -- Switch to editor instead of closing
            end,
            mode = "n",
            desc = "Switch to editor",
          },
          -- Press Ctrl-c in normal mode to switch to editor  
          claude_ctrlc = {
            "<C-c>",
            function()
              vim.cmd("wincmd h")  -- Just switch to left window
            end,
            mode = "n",
            desc = "Switch to editor",
          },
          -- Handle double Ctrl-c to not kill the terminal
          claude_ctrlc_double = {
            "<C-c><C-c>",
            function()
              vim.cmd("wincmd h")  -- Just switch to left window
            end,
            mode = "n",
            desc = "Switch to editor",
          },
          -- Also handle in terminal mode
          claude_ctrlc_term = {
            "<C-c><C-c>",
            function()
              vim.cmd("stopinsert")  -- Exit terminal mode
              vim.cmd("wincmd h")    -- Switch to editor
            end,
            mode = "t",
            desc = "Switch to editor",
          },
        },
      },
    },
  })
end

EOF