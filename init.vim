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

" Markdown plugins
Plug 'preservim/vim-markdown'                " Markdown folding and syntax
Plug 'sbdchd/neoformat'                      " Formatting tool for prettier

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

" Table formatting and alignment
Plug 'dhruvasagar/vim-table-mode'            " Better table support
Plug 'gabrielelana/vim-markdown'             " Alternative markdown with better rendering
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
set foldenable                  " Enable folding

" Color scheme configuration
set background=light
" Try multiple light themes in order of preference
silent! colorscheme github_light
if !exists('g:colors_name') || g:colors_name != 'github_light'
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

" Folding keybindings
nnoremap <space>za za  " Toggle fold under cursor
nnoremap <space>zA zA  " Toggle all folds recursively under cursor
nnoremap <space>zc zc  " Close fold under cursor
nnoremap <space>zo zo  " Open fold under cursor
nnoremap <space>zC zC  " Close all folds recursively under cursor
nnoremap <space>zO zO  " Open all folds recursively under cursor
nnoremap <space>zr zr  " Reduce folding level by one
nnoremap <space>zR zR  " Open all folds
nnoremap <space>zm zm  " Increase folding level by one
nnoremap <space>zM zM  " Close all folds

" Markdown specific settings
augroup markdown_settings
  autocmd!
  autocmd FileType markdown setlocal conceallevel=2  " Hide markdown syntax but show it in tables
  autocmd FileType markdown setlocal concealcursor=n " Show syntax in insert/visual modes
  autocmd FileType markdown setlocal wrap            " Wrap lines
  autocmd FileType markdown setlocal linebreak       " Break at word boundaries
  autocmd FileType markdown setlocal textwidth=0     " Don't auto-wrap (interferes with tables)
  autocmd FileType markdown setlocal expandtab       " Use spaces for alignment
  autocmd FileType markdown setlocal tabstop=4       " Tab width
  autocmd FileType markdown setlocal shiftwidth=4    " Indent width
  " Use markdown folding for markdown files
  autocmd FileType markdown setlocal foldmethod=expr
  autocmd FileType markdown setlocal foldexpr=MarkdownFold()
augroup END

" Markdown folding expression
function! MarkdownFold()
  let line = getline(v:lnum)
  
  " Headers create folds
  if line =~ '^#\+ '
    return '>' . (len(matchstr(line, '^#\+')) - 1)
  endif
  
  " Code blocks
  if line =~ '^```'
    if b:markdown_in_code_block
      let b:markdown_in_code_block = 0
      return '<1'
    else
      let b:markdown_in_code_block = 1
      return '>1'
    endif
  endif
  
  return '='
endfunction

" Initialize markdown code block tracking
autocmd BufEnter *.md let b:markdown_in_code_block = 0

" Neoformat configuration for markdown
let g:neoformat_enabled_markdown = ['prettier']
let g:neoformat_markdown_prettier = {
    \ 'exe': 'prettier',
    \ 'args': ['--stdin-filepath', '"%:p"', '--print-width', '80', '--prose-wrap', 'always'],
    \ 'stdin': 1,
    \ }

" Format on save for markdown
augroup fmt
  autocmd!
  autocmd BufWritePre *.md Neoformat
augroup END

" Manual formatting command
nnoremap <leader>fm :Neoformat<CR>

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
nnoremap <leader>ac :ClaudeCode --dangerously-skip-permissions<CR>
nnoremap <leader>af :ClaudeCodeFocus<CR>
nnoremap <leader>ar :ClaudeCode --dangerously-skip-permissions --resume<CR>
nnoremap <leader>aC :ClaudeCode --dangerously-skip-permissions --continue<CR>
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
      and "~/.claude/local/claude --dangerously-skip-permissions" 
      or "claude --dangerously-skip-permissions",
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
" Enhanced Markdown Configuration
" Enable concealing for cleaner markdown display
let g:vim_markdown_conceal = 2
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_folding_disabled = 0
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext = 0
let g:vim_markdown_folding_level = 6
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_emphasis_multiline = 1
let g:vim_markdown_fenced_languages = ['python=python', 'js=javascript', 'rust=rust', 'bash=sh']
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_strikethrough = 1

" Set conceallevel for markdown files - removed, handled in markdown_settings augroup

" Treesitter configuration for syntax highlighting
lua << END
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "markdown", "markdown_inline", "python", "javascript", "rust", "bash", "json", "yaml", "toml" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}
END

" Enhanced colors for markdown headers - removed, handled in SetMarkdownHighlights

" Disable swap files
set noswapfile
set nobackup
set nowritebackup

" Fix markdown headers and tables
" Enable better markdown rendering
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_new_list_item_indent = 2

" Ensure Treesitter handles markdown properly
lua << END
-- Ensure markdown and markdown_inline are properly configured
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Enable Treesitter highlighting
    vim.cmd("TSBufEnable highlight")
    
    -- Apply our custom highlights after a delay to override plugin defaults
    vim.defer_fn(function()
      vim.cmd("call SetMarkdownHighlights()")
    end, 100)
    
    -- Ensure conceallevel is set for clean display
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "n"
  end,
})
END

" Force reload markdown files to apply settings

" Table mode configuration
let g:table_mode_corner='|'
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='-'
let g:table_mode_fillchar=' '
let g:table_mode_map_prefix = '<leader>t'
let g:table_mode_toggle_map = 'm'
let g:table_mode_always_active = 0
let g:table_mode_delimiter = ' '
let g:table_mode_align_char = '|'
let g:table_mode_syntax = 1
let g:table_mode_auto_align = 1
let g:table_mode_update_time = 500
let g:table_mode_disable_mappings = 0
let g:table_mode_disable_tableize_mappings = 0

" Table mode keybindings
nnoremap <leader>tm :TableModeToggle<CR>
nnoremap <leader>tt :Tableize<CR>
vnoremap <leader>tt :Tableize<CR>
nnoremap <leader>ts :TableSort<CR>
nnoremap <leader>tdd :TableDeleteRow<CR>
nnoremap <leader>tdc :TableDeleteColumn<CR>
nnoremap <leader>tic :TableAddColumn<CR>

" Use || to trigger table header separator
inoremap <Bar><Bar> <Bar><CR><Bar>-<CR><Bar>
" Use || in normal mode to create a separator
nnoremap <leader>t<Bar> :normal! o<Bar>-<CR>

" Table realignment/formatting commands
" Main command to realign tables (this should work)
nnoremap <leader>tr :TableModeRealign<CR>
vnoremap <leader>tr :TableModeRealign<CR>

" Alternative using the internal function directly
nnoremap <leader>ta :call tablemode#table#Realign('.')<CR>
vnoremap <leader>ta :call tablemode#table#Realign('.')<CR>

" Quick realign with double pipe
nnoremap <leader>\|\| :TableModeRealign<CR>

" Enable table mode for markdown files automatically
augroup TableModeActivation
  autocmd!
  autocmd FileType markdown :silent! TableModeEnable
  autocmd BufEnter *.md :silent! TableModeEnable
  autocmd BufRead *.md :silent! TableModeEnable
  autocmd BufNewFile *.md :silent! TableModeEnable
augroup END

" Better highlighting with your colorscheme
function! SetMarkdownHighlights()
  " Clear any existing highlights first
  hi clear markdownH1
  hi clear markdownH2
  hi clear markdownH3
  hi clear markdownH4
  hi clear markdownH5
  hi clear markdownH6
  
  " Headers with darker colors for white background (no background)
  hi markdownH1 guifg=#d73a49 gui=bold
  hi markdownH2 guifg=#6f42c1 gui=bold
  hi markdownH3 guifg=#735c0f gui=bold
  hi markdownH4 guifg=#28a745 gui=bold
  hi markdownH5 guifg=#0366d6 gui=bold
  hi markdownH6 guifg=#ea4a5a gui=bold
  
  " Treesitter markdown groups
  hi @markup.heading.1.markdown guifg=#d73a49 gui=bold
  hi @markup.heading.2.markdown guifg=#6f42c1 gui=bold
  hi @markup.heading.3.markdown guifg=#735c0f gui=bold
  hi @markup.heading.4.markdown guifg=#28a745 gui=bold
  hi @markup.heading.5.markdown guifg=#0366d6 gui=bold
  hi @markup.heading.6.markdown guifg=#ea4a5a gui=bold
  
  " Legacy Treesitter groups (for compatibility)
  hi @text.title.1.markdown guifg=#d73a49 gui=bold
  hi @text.title.2.markdown guifg=#6f42c1 gui=bold
  hi @text.title.3.markdown guifg=#735c0f gui=bold
  hi @text.title.4.markdown guifg=#28a745 gui=bold
  hi @text.title.5.markdown guifg=#0366d6 gui=bold
  hi @text.title.6.markdown guifg=#ea4a5a gui=bold
  
  " Markdown elements with darker colors
  hi markdownBold guifg=#bf5000 gui=bold
  hi markdownItalic guifg=#6f42c1 gui=italic
  hi markdownCode guifg=#032f62 guibg=#f6f8fa
  hi markdownCodeBlock guifg=#032f62 guibg=#f6f8fa
  hi markdownLink guifg=#0366d6 gui=underline
  
  " Tables with darker colors
  hi markdownTable guifg=#586069
  hi markdownTableDelimiter guifg=#959da5
  
  " Treesitter table groups
  hi @text.table.markdown guifg=#586069
  hi @markup.table.markdown guifg=#586069
  hi @punctuation.special.markdown guifg=#959da5
endfunction

" Apply highlights on colorscheme change and file open
autocmd ColorScheme * call SetMarkdownHighlights()
autocmd FileType markdown call SetMarkdownHighlights()

" Call it immediately
call SetMarkdownHighlights()

" Map ; to : for easier command mode access
nnoremap ; :
vnoremap ; :

" Ensure markdown highlights persist after reload
augroup MarkdownHighlights
  autocmd!
  " Apply after VimEnter to override any plugin settings
  autocmd VimEnter * call SetMarkdownHighlights()
  " Immediate application on file events
  autocmd BufEnter *.md call SetMarkdownHighlights()
  autocmd BufRead *.md call SetMarkdownHighlights()
  autocmd BufNewFile *.md call SetMarkdownHighlights()
  " Delayed application to override plugins
  autocmd BufEnter *.md call timer_start(10, {-> execute('call SetMarkdownHighlights()')})
  autocmd BufRead *.md call timer_start(10, {-> execute('call SetMarkdownHighlights()')})
  autocmd BufNewFile *.md call timer_start(10, {-> execute('call SetMarkdownHighlights()')})
  " Multiple delays to ensure it sticks
  autocmd BufEnter *.md call timer_start(100, {-> execute('call SetMarkdownHighlights()')})
  autocmd BufEnter *.md call timer_start(200, {-> execute('call SetMarkdownHighlights()')})
  " Reapply after sourcing vimrc
  autocmd SourcePost * call SetMarkdownHighlights()
  " Apply after any filetype change
  autocmd FileType markdown call SetMarkdownHighlights()
  autocmd FileType markdown call timer_start(50, {-> execute('call SetMarkdownHighlights()')})
  autocmd FileType markdown call timer_start(150, {-> execute('call SetMarkdownHighlights()')})
  " Apply after syntax is set
  autocmd Syntax markdown call SetMarkdownHighlights()
  autocmd Syntax markdown call timer_start(100, {-> execute('call SetMarkdownHighlights()')})
  " Apply after buffer is fully loaded
  autocmd BufWinEnter *.md call SetMarkdownHighlights()
  autocmd BufWinEnter *.md call timer_start(150, {-> execute('call SetMarkdownHighlights()')})
  " Apply when cursor is held (idle)
  autocmd CursorHold *.md call SetMarkdownHighlights()
augroup END

" Force Treesitter highlighting for markdown
augroup TreesitterMarkdown
  autocmd!
  autocmd FileType markdown TSBufEnable highlight
  autocmd BufRead *.md TSBufEnable highlight
  autocmd BufNewFile *.md TSBufEnable highlight
  " Ensure Treesitter loads before our highlights
  autocmd FileType markdown call timer_start(50, {-> execute('TSBufEnable highlight')})
augroup END

" Multiple delayed applications to ensure it overrides everything
autocmd VimEnter * call timer_start(100, {-> execute('call SetMarkdownHighlights()')})
autocmd VimEnter * call timer_start(200, {-> execute('call SetMarkdownHighlights()')})
autocmd VimEnter * call timer_start(500, {-> execute('call SetMarkdownHighlights()')})
