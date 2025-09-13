" Disable NERDCommenter default mappings before plugin loads
let g:NERDCreateDefaultMappings = 0

" Vim-Plug plugin manager
call plug#begin('~/.config/nvim/plugged')

" Essential Rust plugins
Plug 'rust-lang/rust.vim'                    " Official Rust plugin
Plug 'neovim/nvim-lspconfig'                 " LSP configuration
Plug 'stevearc/aerial.nvim'                  " Code outline/symbol viewer

" Additional useful plugins
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Better syntax highlighting
Plug 'nvim-telescope/telescope.nvim'         " Fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'} " Better performance
Plug 'nvim-lua/plenary.nvim'                 " Required by telescope
Plug 'nvim-tree/nvim-tree.lua'               " Modern file explorer
Plug 'nvim-tree/nvim-web-devicons'           " File icons for nvim-tree
Plug 'folke/which-key.nvim'                  " Shows keybindings as you type
Plug 'vim-airline/vim-airline'               " Status line
Plug 'vim-airline/vim-airline-themes'        " Status line themes
Plug 'tpope/vim-fugitive'                    " Git integration
Plug 'airblade/vim-gitgutter'                " Git diff markers
Plug 'scrooloose/nerdcommenter'              " Easy commenting
Plug 'jiangmiao/auto-pairs'                  " Auto close brackets
Plug 'coder/claudecode.nvim'                 " Claude Code in Neovim
Plug 'folke/snacks.nvim'                     " Required for claudecode.nvim

" Markdown plugins
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

" Systemd syntax highlighting
Plug 'chr4/nginx.vim'                        " Nginx syntax (often used with systemd)
Plug 'wgwoods/vim-systemd-syntax'            " Systemd unit file syntax
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
set clipboard=unnamedplus       " Use system clipboard (will be overridden for SSH)
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
let g:rust_fold = 0

" LSP keybindings will be set in Lua config below
" Navigation keybindings (will be mapped to LSP in Lua)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>f <cmd>lua vim.lsp.buf.format()<CR>
nnoremap <silent> [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <leader>q <cmd>lua vim.diagnostic.setloclist()<CR>

" Aerial (code outline) keybindings
nnoremap <leader>a <cmd>AerialToggle!<CR>
nnoremap <leader>A <cmd>AerialNavToggle<CR>
nnoremap [s <cmd>AerialPrev<CR>
nnoremap ]s <cmd>AerialNext<CR>
nnoremap <leader>as <cmd>AerialGo<CR>
nnoremap <leader>at <cmd>AerialTreeToggle<CR>
nnoremap <leader>ai <cmd>AerialInfo<CR>

" Airline configuration
let g:airline_theme = 'papercolor'
let g:airline_powerline_fonts = 1

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
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap <leader>ft <cmd>Telescope builtin<cr>

" Alternative grep commands (working fallbacks)
nnoremap <leader>rg :Rg<Space>
" Removed <leader>R mapping - was RgInteractive

" Debug telescope command
command! TelescopeDebug lua print('rg test:'); print(vim.fn.system('rg --version')); print('Telescope config:'); print(vim.inspect(require('telescope.config').values.vimgrep_arguments))
command! TelescopeTest lua require('telescope.builtin').live_grep({prompt_title = 'Test Live Grep'})
command! RgTest lua print('Direct rg test:'); print(vim.fn.system('rg --color=never --no-heading --with-filename --line-number --column fn src/main.rs'))
command! -nargs=1 Rg lua vim.fn.setqflist({}); vim.fn.setqflist(vim.fn.systemlist('rg --vimgrep ' .. vim.fn.shellescape(<q-args>)), 'r'); vim.cmd('copen')
command! RgInteractive lua vim.ui.input({prompt = 'Search: '}, function(input) if input then vim.cmd('Rg ' .. input) end end)

" Alternative working live grep using Telescope grep_string
command! -nargs=1 Tgrep lua require('telescope.builtin').grep_string({search = <q-args>})
nnoremap <leader>gs :Tgrep<Space>


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

" Rust specific folding settings
augroup rust_folding
  autocmd!
  autocmd FileType rust setlocal foldmethod=expr
  autocmd FileType rust setlocal foldexpr=nvim_treesitter#foldexpr()
  autocmd FileType rust setlocal foldlevelstart=99
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


" Reload config
nnoremap <leader>rc :source ~/.config/nvim/init.vim<CR>:echo "Config reloaded"<CR>

" Systemd file type detection
augroup systemd_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.service set filetype=systemd
  autocmd BufRead,BufNewFile *.timer set filetype=systemd
  autocmd BufRead,BufNewFile *.mount set filetype=systemd
  autocmd BufRead,BufNewFile *.automount set filetype=systemd
  autocmd BufRead,BufNewFile *.swap set filetype=systemd
  autocmd BufRead,BufNewFile *.target set filetype=systemd
  autocmd BufRead,BufNewFile *.path set filetype=systemd
  autocmd BufRead,BufNewFile *.socket set filetype=systemd
  autocmd BufRead,BufNewFile *.device set filetype=systemd
  autocmd BufRead,BufNewFile *.scope set filetype=systemd
  autocmd BufRead,BufNewFile *.slice set filetype=systemd
  autocmd BufRead,BufNewFile /etc/systemd/* set filetype=systemd
augroup END

" Unmap unwanted leader mappings
silent! nunmap <leader>e
silent! nunmap <leader>q
silent! nunmap <leader>g

" Explicitly unmap any NERDCommenter leader mappings
silent! nunmap <leader>cc
silent! nunmap <leader>cn
silent! nunmap <leader>c<space>
silent! nunmap <leader>cm
silent! nunmap <leader>ci
silent! nunmap <leader>cs
silent! nunmap <leader>cy
silent! nunmap <leader>c$
silent! nunmap <leader>cA
silent! nunmap <leader>ca
silent! nunmap <leader>cl
silent! nunmap <leader>cb
silent! nunmap <leader>cu
silent! vunmap <leader>cc
silent! vunmap <leader>cn
silent! vunmap <leader>cm
silent! vunmap <leader>ci
silent! vunmap <leader>cs
silent! vunmap <leader>cy
silent! vunmap <leader>c$
silent! vunmap <leader>cA
silent! vunmap <leader>ca
silent! vunmap <leader>cl
silent! vunmap <leader>cb
silent! vunmap <leader>cu

" ClaudeCode keybindings - all under <leader>c prefix
" Open/focus Claude
nnoremap <leader>co :ClaudeCodeFocus<CR>
" Close Claude window from anywhere (keeps session running)
nnoremap <leader>cc :lua for _, win in ipairs(vim.api.nvim_list_wins()) do local buf = vim.api.nvim_win_get_buf(win); if vim.api.nvim_buf_get_name(buf):match("claude") or vim.api.nvim_buf_get_name(buf):match("ClaudeCode") then vim.api.nvim_win_close(win, false); break end end<CR>
nnoremap <leader>cf :ClaudeCodeFocus<CR>
nnoremap <leader>cr :ClaudeCode --resume<CR>
nnoremap <leader>cC :ClaudeCode --continue<CR>
nnoremap <leader>cm :ClaudeCodeSelectModel<CR>
nnoremap <leader>cb :ClaudeCodeAdd %<CR>
vnoremap <leader>cs :ClaudeCodeSend<CR>
nnoremap <leader>ca :ClaudeCodeDiffAccept<CR>
nnoremap <leader>cd :ClaudeCodeDiffDeny<CR>

" NERDCommenter mappings - using gc prefix (no leader key)
" gc = comment toggle, gu = uncomment
nmap gcc <Plug>NERDCommenterToggle
vmap gc <Plug>NERDCommenterToggle
nmap gcl <Plug>NERDCommenterAlignLeft
nmap gca <Plug>NERDCommenterAppend
nmap gcy <Plug>NERDCommenterYank
nmap gcs <Plug>NERDCommenterSexy
nmap gcu <Plug>NERDCommenterUncomment
nmap gcn <Plug>NERDCommenterNested
nmap gcm <Plug>NERDCommenterMinimal
nmap gci <Plug>NERDCommenterInvert
nmap gc$ <Plug>NERDCommenterToEOL

" Find keymaps - search through all mappings
nnoremap <leader>fk :Telescope keymaps<CR>

" Visual differentiation for terminal windows (Claude Code)
" Make inactive terminal windows dimmer without cursor manipulation
augroup TerminalVisibility
  autocmd!
  " Make inactive terminal windows dimmer for better visibility
  autocmd WinEnter * if &buftype == 'terminal' | setlocal winhighlight=Normal:Normal | endif
  autocmd WinLeave * if &buftype == 'terminal' | setlocal winhighlight=Normal:NonText | endif
augroup END

" Visual indicators for active window (including terminal splits)
set cursorline                  " Highlight current line in active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" Terminal mode window navigation
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>l <C-\><C-n><C-w>l
tnoremap <C-h> <C-\><C-n><C-w>h

" Double Ctrl-c to switch between Claude and editor
" From editor to Claude (right window)
nnoremap <C-c><C-c> <cmd>wincmd l<CR>
inoremap <C-c><C-c> <Esc><cmd>wincmd l<CR>

" From terminal to editor (left window) - terminal mode mapping
tnoremap <C-c><C-c> <C-\><C-n><cmd>wincmd h<CR>



" OSC 52 Clipboard Configuration for SSH
" This enables clipboard support when running Neovim on a remote server
if !empty($SSH_TTY)
  " We're in an SSH session, use OSC 52 for clipboard
  let g:clipboard = {
    \   'name': 'OSC 52',
    \   'copy': {
    \      '+': {lines, regtype -> system('printf "\033]52;c;%s\a" "$(printf "%s" "' . join(lines, "\n") . '" | base64 -w0)"')},
    \      '*': {lines, regtype -> system('printf "\033]52;c;%s\a" "$(printf "%s" "' . join(lines, "\n") . '" | base64 -w0)"')},
    \    },
    \   'paste': {
    \      '+': {-> []},
    \      '*': {-> []},
    \   },
    \ }
  
  " Alternative Lua-based OSC 52 implementation for better performance
  lua << OSCLUA
  -- OSC 52 clipboard provider for Neovim over SSH
  local function copy(lines, _)
    local content = table.concat(lines, '\n')
    local base64 = vim.fn.system('base64 -w0', content)
    base64 = base64:gsub('\n', '')
    local osc52 = string.format('\027]52;c;%s\a', base64)
    
    -- Send to terminal
    io.stdout:write(osc52)
    io.stdout:flush()
  end

  -- Only override if we're in SSH session
  if vim.env.SSH_TTY and vim.env.SSH_TTY ~= '' then
    vim.g.clipboard = {
      name = 'OSC52',
      copy = {
        ['+'] = copy,
        ['*'] = copy,
      },
      paste = {
        ['+'] = function() return {} end,
        ['*'] = function() return {} end,
      },
    }
  end
OSCLUA
endif

" Lua configuration
lua << EOF
-- LSP Configuration
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if lspconfig_ok then
  -- rust-analyzer setup
  lspconfig.rust_analyzer.setup({
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = true,
        check = {
          command = "clippy",
          allFeatures = true,
        },
        procMacro = {
          enable = true,
        },
        files = {
          excludeDirs = {
            ".cargo",
            ".rustup", 
            "target",
            ".git",
          },
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true,
          },
        },
      },
    },
    on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      
      -- Diagnostic config
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
      
      -- Set diagnostic signs
      local signs = { Error = "✗", Warn = "⚠", Hint = "💡", Info = "ℹ" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  })
end

-- Aerial configuration (code outline)
local aerial_ok, aerial = pcall(require, "aerial")
if aerial_ok then
  aerial.setup({
    backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
    layout = {
      max_width = { 40, 0.2 },
      width = nil,
      min_width = 20,
      default_direction = "right",
      placement = "window",
    },
    attach_mode = "window",
    close_automatic_events = {},
    
    -- Disable line numbers in Aerial window
    show_numbers = false,
    
    -- Callback to set window options when Aerial opens
    on_attach = function(bufnr)
      -- Only disable line numbers if this is actually the aerial buffer
      vim.api.nvim_buf_call(bufnr, function()
        if vim.bo.filetype == 'aerial' then
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
        end
      end)
    end,
    
    -- Cursor synchronization settings
    autojump = true,  -- Jump to symbol when navigating in Aerial
    highlight_on_hover = true,  -- Highlight symbol in code when hovering in Aerial
    highlight_on_jump = 300,  -- Highlight for 300ms after jumping
    
    -- Update Aerial position when cursor moves in code
    update_events = "TextChanged,InsertLeave,WinEnter,WinLeave,BufWinEnter",
    
    -- Follow cursor in code file
    post_jump_cmd = "normal! zz",  -- Center the line after jumping
    
    -- Link cursor position between windows
    link_folds_to_tree = false,
    link_tree_to_folds = false,
    manage_folds = false,
    
    -- Show current location in Aerial
    show_current_context = true,
    highlight_closest = true,
    highlight_mode = "split_width",
    keymaps = {
      ["?"] = "actions.show_help",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.jump",
      ["<2-LeftMouse>"] = "actions.jump",
      ["<C-v>"] = "actions.jump_vsplit",
      ["<C-s>"] = "actions.jump_split",
      ["p"] = "actions.scroll",
      ["<C-j>"] = "actions.down_and_scroll",
      ["<C-k>"] = "actions.up_and_scroll",
      ["{"] = "actions.prev",
      ["}"] = "actions.next",
      ["[["] = "actions.prev_up",
      ["]]"] = "actions.next_up",
      ["q"] = "actions.close",
      ["o"] = "actions.tree_toggle",
      ["za"] = "actions.tree_toggle",
      ["O"] = "actions.tree_toggle_recursive",
      ["zA"] = "actions.tree_toggle_recursive",
      ["l"] = "actions.tree_open",
      ["zo"] = "actions.tree_open",
      ["L"] = "actions.tree_open_recursive",
      ["zO"] = "actions.tree_open_recursive",
      ["h"] = "actions.tree_close",
      ["zc"] = "actions.tree_close",
      ["H"] = "actions.tree_close_recursive",
      ["zC"] = "actions.tree_close_recursive",
      ["zr"] = "actions.tree_increase_fold_level",
      ["zR"] = "actions.tree_open_all",
      ["zm"] = "actions.tree_decrease_fold_level",
      ["zM"] = "actions.tree_close_all",
      ["zx"] = "actions.tree_sync_folds",
      ["zX"] = "actions.tree_sync_folds",
    },
    filter_kind = false,
    icons = {
      -- Rust-specific icons with better visibility
      Module = " 📦 ",
      Namespace = " 🗂 ",
      Package = " 📦 ",
      Class = " 🏛 ",
      Struct = " 🏗 ",
      Enum = " 📋 ",
      Interface = " 🔌 ",
      Function = " 🔧 ",
      Method = " 🔨 ",
      Constructor = " 🏗 ",
      Field = " 🏷 ",
      Variable = " 📝 ",
      Constant = " 🔒 ",
      String = " 💬 ",
      Number = " 🔢 ",
      Boolean = " ✓ ",
      Array = " 📚 ",
      Object = " 📦 ",
      Key = " 🔑 ",
      Null = " ∅ ",
      EnumMember = " 📍 ",
      Property = " 📌 ",
      Event = " ⚡ ",
      Operator = " ⚙ ",
      TypeParameter = " 📐 ",
      File = " 📄 ",
      Folder = " 📁 ",
      Trait = " 🔗 ",
      Impl = " 🔧 ",
      Macro = " ⚡ ",
    },
    show_guides = true,
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top = "│ ",
      whitespace = "  ",
    },
  })
end

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

-- Which-key configuration
local whichkey_ok, which_key = pcall(require, "which-key")
if whichkey_ok then
  which_key.setup({
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    window = {
      border = "rounded",
      position = "bottom",
      margin = {1, 0, 1, 0},
      padding = {2, 2, 2, 2},
    },
    layout = {
      height = {min = 4, max = 25},
      width = {min = 20, max = 50},
      spacing = 3,
      align = "left",
    },
    show_help = true,
    triggers = "auto",
  })
  
  -- Register mappings with descriptions
  which_key.register({
    ["<leader>"] = {
      a = "Toggle Aerial (code outline)",
      A = "Toggle Aerial navigation",
      c = {
        name = "Claude Code",
        c = "Start Claude Code",
        f = "Focus Claude",
        r = "Resume Claude",
        C = "Continue Claude",
        m = "Select Model",
        b = "Add Buffer",
        s = "Send Selection",
        a = "Accept Diff",
        d = "Deny Diff",
      },
      f = {
        name = "Find/Search",
        f = "Find Files",
        g = "Grep String",
        b = "Find Buffers",
        h = "Help Tags",
        s = "LSP Symbols",
        t = "Telescope Commands",
        m = "Format (Neoformat)",
      },
      g = {
        name = "Git/Grep",
        s = "Grep with Input",
      },
      n = {
        name = "NvimTree",
        t = "Toggle Tree",
        f = "Find File in Tree",
        c = "Collapse Tree",
      },
      r = {
        name = "Rust/Reload",
        n = "Rename (ALE)",
        c = "Reload Config",
        g = "Ripgrep",
      },
      t = {
        name = "Table Mode",
        m = "Toggle Table Mode",
        t = "Tableize",
        s = "Sort Table",
        r = "Realign Table",
        a = "Realign (Alt)",
        ["||"] = "Quick Realign",
        ["|"] = "Add Separator",
        d = {
          name = "Delete",
          d = "Delete Row",
          c = "Delete Column",
        },
        i = {
          name = "Insert",
          c = "Add Column",
        },
      },
    },
    g = {
      d = "Go to Definition",
      D = "Go to Declaration", 
      r = "Find References",
      i = "Go to Implementation",
    },
    K = "Show Hover",
    ["["] = {
      d = "Previous Diagnostic",
      s = "Previous Symbol (Aerial)",
    },
    ["]"] = {
      d = "Next Diagnostic", 
      s = "Next Symbol (Aerial)",
    },
  })
end

-- ClaudeCode configuration
local claudecode_ok, claudecode = pcall(require, "claudecode")
if claudecode_ok then
  claudecode.setup({
    -- Use local installation if available, otherwise global, with --dangerously-skip-permissions flag
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

" Aerial highlighting - colorful symbols for better visibility
function! SetAerialHighlights()
  " Symbol type highlights with vibrant colors
  hi AerialClass guifg=#6f42c1 gui=bold
  hi AerialClassIcon guifg=#6f42c1 gui=bold
  hi AerialStruct guifg=#0366d6 gui=bold
  hi AerialStructIcon guifg=#0366d6 gui=bold
  hi AerialEnum guifg=#28a745 gui=bold
  hi AerialEnumIcon guifg=#28a745 gui=bold
  hi AerialInterface guifg=#ea4a5a gui=bold
  hi AerialInterfaceIcon guifg=#ea4a5a gui=bold
  hi AerialFunction guifg=#d73a49 gui=bold
  hi AerialFunctionIcon guifg=#d73a49 gui=bold
  hi AerialMethod guifg=#e36209 gui=bold
  hi AerialMethodIcon guifg=#e36209 gui=bold
  hi AerialConstructor guifg=#6f42c1 gui=bold
  hi AerialConstructorIcon guifg=#6f42c1 gui=bold
  hi AerialField guifg=#735c0f gui=bold
  hi AerialFieldIcon guifg=#735c0f gui=bold
  hi AerialProperty guifg=#735c0f gui=bold
  hi AerialPropertyIcon guifg=#735c0f gui=bold
  hi AerialEvent guifg=#b08800 gui=bold
  hi AerialEventIcon guifg=#b08800 gui=bold
  hi AerialOperator guifg=#032f62 gui=bold
  hi AerialOperatorIcon guifg=#032f62 gui=bold
  hi AerialTypeParameter guifg=#b08800 gui=italic
  hi AerialTypeParameterIcon guifg=#b08800 gui=italic
  hi AerialKey guifg=#005cc5 gui=bold
  hi AerialKeyIcon guifg=#005cc5 gui=bold
  hi AerialVariable guifg=#032f62 gui=bold
  hi AerialVariableIcon guifg=#032f62 gui=bold
  hi AerialConstant guifg=#005cc5 gui=bold
  hi AerialConstantIcon guifg=#005cc5 gui=bold
  hi AerialString guifg=#032f62 gui=italic
  hi AerialStringIcon guifg=#032f62 gui=italic
  hi AerialNumber guifg=#005cc5 gui=bold
  hi AerialNumberIcon guifg=#005cc5 gui=bold
  hi AerialBoolean guifg=#005cc5 gui=bold
  hi AerialBooleanIcon guifg=#005cc5 gui=bold
  hi AerialArray guifg=#e36209 gui=bold
  hi AerialArrayIcon guifg=#e36209 gui=bold
  hi AerialObject guifg=#6f42c1 gui=bold
  hi AerialObjectIcon guifg=#6f42c1 gui=bold
  hi AerialModule guifg=#6f42c1 gui=bold
  hi AerialModuleIcon guifg=#6f42c1 gui=bold
  hi AerialNamespace guifg=#6f42c1 gui=bold
  hi AerialNamespaceIcon guifg=#6f42c1 gui=bold
  hi AerialPackage guifg=#6f42c1 gui=bold
  hi AerialPackageIcon guifg=#6f42c1 gui=bold
  hi AerialFile guifg=#586069 gui=bold
  hi AerialFileIcon guifg=#586069 gui=bold
  hi AerialEnumMember guifg=#22863a gui=italic
  hi AerialEnumMemberIcon guifg=#22863a gui=italic
  hi AerialNull guifg=#959da5 gui=italic
  hi AerialNullIcon guifg=#959da5 gui=italic
  
  " Guide lines and tree structure
  hi AerialGuide guifg=#959da5
  hi AerialLine guifg=#d73a49 gui=bold
  
  " Special Rust-specific highlights
  hi link AerialImpl AerialInterface
  hi link AerialImplIcon AerialInterfaceIcon
  hi link AerialTrait AerialInterface
  hi link AerialTraitIcon AerialInterfaceIcon
  hi link AerialMacro AerialFunction
  hi link AerialMacroIcon AerialFunctionIcon
  
  " Aerial window background and borders
  hi AerialNormal guibg=#fafbfc
  hi AerialBorder guifg=#d1d5da gui=bold
  hi AerialWinSeparator guifg=#d1d5da gui=bold
  
  " Line highlighting in Aerial window
  hi AerialLineNC guibg=#f6f8fa
  hi AerialCursorLine guibg=#fff5b1 gui=bold
endfunction

" Apply Aerial highlights
autocmd ColorScheme * call SetAerialHighlights()
autocmd VimEnter * call SetAerialHighlights()
call SetAerialHighlights()

" Auto-sync Aerial cursor with main buffer cursor
augroup AerialSync
  autocmd!
  " Update Aerial position when cursor moves
  autocmd CursorMoved * silent! lua require('aerial').sync_position()
  autocmd CursorMovedI * silent! lua require('aerial').sync_position()
  " Update when entering a window
  autocmd BufWinEnter * silent! lua require('aerial').sync_position()
  autocmd WinEnter * silent! lua require('aerial').sync_position()
  " Disable line numbers ONLY in Aerial windows
  autocmd BufWinEnter * if &filetype == 'aerial' | setlocal nonumber norelativenumber signcolumn=no | endif
  autocmd WinEnter * if &filetype == 'aerial' | setlocal nonumber norelativenumber signcolumn=no | endif
augroup END

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
