## Interdependencies among plugins

The plugins' dependency tree is as follows _(click to enlarge)_:

[![deps-diag](https://github.com/ayamir/nvimdots/assets/50296129/fda56f7f-85d8-46f9-9c68-71c2ee5da5d4)
](https://github.com/ayamir/nvimdots/assets/50296129/fda56f7f-85d8-46f9-9c68-71c2ee5da5d4)

- Legend:

```console
┌─┐             ┌─┐
│A│ ──────────► │B│     Arrow indicates "B is loaded after A"
└─┘             └─┘

┌─┐             ┌─┐
│A│ ─  ─  ─  ─► │B│     Dotted line arrow indicates "B depends on A, or A must be loaded before B"
└─┘             └─┘

* Neovim begins loading from `init`.

* Light blue circles represent events.

* Dark blue circles represent plugin names, with octagons denoting optional plugins.

* The green circle denotes the core plugin of the language server.

* Self-contained plugins load themselves when required.
```

<details>
    <summary>Source code in graphviz format</summary>
<p>

```diag
digraph plugins_load_seq {
	ratio = fill;
	node [style=filled];
	init -> opt [color="0.649 0.701 0.701"];
	init -> start [color="0.649 0.701 0.701"];
	init -> "self-contained" [color="0.649 0.701 0.701"];
	start -> "catppuccin" [color="0.649 0.701 0.701"];
	start -> "bigfile.nvim" [color="0.649 0.701 0.701"];
	start -> "dropbar.nvim" [color="0.649 0.701 0.701"];

	opt -> VeryLazy [color="0.619 0.714 0.714"];
	opt -> BufNewFile [color="0.619 0.714 0.714"];
	opt -> CursorHold [color="0.619 0.714 0.714"];
	CursorHoldI -> CursorHold [color="0.619 0.714 0.714" style="dashed"];
	VeryLazy -> BufWinEnter [color="0.619 0.714 0.714"];
	BufWinEnter -> BufAdd [color="0.619 0.714 0.714"];
	BufAdd -> BufReadPre [color="0.619 0.714 0.714"];
	BufReadPre -> BufReadPost [color="0.619 0.714 0.714"];
	BufReadPost -> LspAttach [color="0.619 0.714 0.714"];
	LspAttach -> InsertEnter [color="0.619 0.714 0.714"];

	VeryLazy -> "nvim-notify" [color="0.649 0.701 0.701"];

	BufWinEnter -> "alpha-nvim" [color="0.649 0.701 0.701"];

	BufNewFile -> "bufferline.nvim" [color="0.649 0.701 0.701"];
	BufNewFile -> "nvim-scrollview" [color="0.649 0.701 0.701"];
	BufNewFile -> "lualine.nvim" [color="0.649 0.701 0.701"];
	BufNewFile -> "local-highlight.nvim" [color="0.649 0.701 0.701"];
	BufNewFile -> "vim-sleuth" [color="0.649 0.701 0.701"];

	BufAdd -> "bufferline.nvim" [color="0.649 0.701 0.701"];
	BufAdd -> "nvim-scrollview" [color="0.649 0.701 0.701"];
	BufAdd -> "lualine.nvim" [color="0.649 0.701 0.701"];
	BufAdd -> "local-highlight.nvim" [color="0.649 0.701 0.701"];

	BufReadPre -> "nvim-treesitter" [color="0.649 0.701 0.701"];
	"nvim-treesitter" -> "nvim-treesitter-context" [color="0.649 0.701 0.701"];
	"nvim-treesitter-context" -> "nvim-treehopper" [color="0.649 0.701 0.701"];
	"nvim-treehopper" -> "rainbow-delimiters.nvim" [color="0.649 0.701 0.701"];
	"rainbow-delimiters.nvim" -> "nvim-treesitter-textobjects" [color="0.649 0.701 0.701"];
	"nvim-treesitter-textobjects" -> "nvim-ts-context-commentstring" [color="0.649 0.701 0.701"];
	"nvim-ts-context-commentstring" -> "nvim-ts-autotag" [color="0.649 0.701 0.701"];
	"nvim-ts-autotag" -> "vim-matchup" [color="0.649 0.701 0.701"];

	BufReadPost -> "hop.nvim" [color="0.649 0.701 0.701"];
	BufReadPost -> "smartyank.nvim" [color="0.649 0.701 0.701"];
	BufReadPost -> "fcitx5.nvim (opt)" [color="0.649 0.701 0.701"];
	BufReadPost -> "indent-blankline.nvim" [color="0.649 0.701 0.701"];
	BufReadPost -> "local-highlight.nvim" [color="0.649 0.701 0.701"];
	BufReadPost -> "bufferline.nvim" [color="0.649 0.701 0.701"];
	BufReadPost -> "vim-sleuth" [color="0.649 0.701 0.701"];
	BufReadPost -> "nvim-scrollview" [color="0.649 0.701 0.701"];

	InsertEnter -> "nvim-cmp" [color="0.649 0.701 0.701"];
	InsertEnter -> "vim-cool" [color="0.649 0.701 0.701"];
	InsertEnter -> "copilot.lua" [color="0.649 0.701 0.701"];
	InsertEnter -> "autoclose.nvim" [color="0.649 0.701 0.701"];
	"copilot.lua" -> "copilot-cmp" [color="0.649 0.701 0.701"];
	"LuaSnip" -> "cmp_luasnip" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-under-comparator" -> "nvim-cmp" [color="0.649 0.701 0.701" style="dashed"];
	"cmp_luasnip" -> "cmp-nvim-lsp" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-nvim-lsp" -> "cmp-nvim-lua" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-nvim-lua" -> "cmp-tmux" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-tmux" -> "cmp-path" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-path" -> "cmp-spell" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-spell" -> "cmp-treesitter" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-treesitter" -> "cmp-buffer" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-buffer" -> "cmp-latex-symbols" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-latex-symbols" -> "cmp-tabnine (opt)" [color="0.649 0.701 0.701" style="dashed"];
	"cmp-tabnine (opt)" -> "codeium.nvim (opt)" [color="0.649 0.701 0.701" style="dashed"];
	"nui.nvim (opt)" -> "codeium.nvim (opt)" [color="0.649 0.701 0.701" style="dashed"];
	"codeium.nvim (opt)" -> "nvim-cmp" [color="0.649 0.701 0.701" style="dashed"];
	"friendly-snippets" -> "LuaSnip" [color="0.649 0.701 0.701" style="dashed"];

	CursorHold -> "Comment.nvim" [color="0.649 0.701 0.701"];
	CursorHold -> "gitsigns.nvim" [color="0.649 0.701 0.701"];
	CursorHold -> "project.nvim" [color="0.649 0.701 0.701"];
	CursorHold -> "smart-splits.nvim" [color="0.649 0.701 0.701"];
	CursorHold -> "flash.nvim" [color="0.649 0.701 0.701"];
	CursorHold -> "neoscroll.nvim" [color="0.649 0.701 0.701"];
	CursorHold -> "nvim-highlight-colors" [color="0.649 0.701 0.701"];
	CursorHold -> "todo-comments.nvim" [color="0.649 0.701 0.701"];
	CursorHold -> "which-key.nvim" [color="0.649 0.701 0.701"];
	CursorHold -> "mini.align" [color="0.649 0.701 0.701"];
	CursorHold -> "paint.nvim" [color="0.649 0.701 0.701"];
	"mason-null-ls.nvim" -> "none-ls.nvim" [color="0.649 0.701 0.701" style="dashed"];
	"plenary.nvim" -> "none-ls.nvim" [color="0.649 0.701 0.701" style="dashed"];
	CursorHold -> "none-ls.nvim" [color="0.649 0.701 0.701"];
	"mason-lspconfig.nvim" -> "mason.nvim" [color="0.649 0.701 0.701" style="dashed"];
	"mason.nvim" -> "nvim-lspconfig" [color="0.649 0.701 0.701" style="dashed"];
	CursorHold -> "nvim-lspconfig" [color="0.649 0.701 0.701"];
	"nvim-web-devicons" -> "lspsaga.nvim" [color="0.649 0.701 0.701" style="dashed"];
	"nvim-lspconfig" -> "lspsaga.nvim" [color="0.649 0.701 0.701"];
	"nvim-lspconfig" -> "neoconf.nvim" [color="0.649 0.701 0.701"];
	"nvim-lspconfig" -> "lsp_signature.nvim" [color="0.649 0.701 0.701"];
	"nvim-lspconfig" -> "lualine.nvim" [color="0.649 0.701 0.701"];
	"nvim-lspconfig" -> "mason.nvim" [color="0.649 0.701 0.701"];
	"lspsaga.nvim" -> "lualine.nvim" [color="0.649 0.701 0.701"];

	LspAttach -> "neodim" [color="0.649 0.701 0.701"];
	LspAttach -> "aerial.nvim" [color="0.649 0.701 0.701"];
	LspAttach -> "glance.nvim" [color="0.649 0.701 0.701"];
	LspAttach -> "fidget.nvim" [color="0.649 0.701 0.701"];
	LspAttach -> "lsp-format-modifications.nvim" [color="0.649 0.701 0.701"];
	"nvim-treesitter" -> "neodim" [color="0.649 0.701 0.701" style="dashed"];

	"self-contained" -> "persisted.nvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "toggleterm.nvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "nvim-bufdel" [color="0.649 0.701 0.701"];
	"self-contained" -> "nvim-bqf" [color="0.649 0.701 0.701"];
	"fzf" -> "nvim-bqf" [color="0.649 0.701 0.701" style="dashed"];
	"self-contained" -> "nvim-dap" [color="0.649 0.701 0.701"];
	"nvim-dap" -> "nvim-dap-ui" [color="0.649 0.701 0.701"];
	"nvim-nio" -> "nvim-dap-ui" [color="0.649 0.701 0.701" style="dashed"];
	"nvim-dap" -> "mason-nvim-dap.nvim" [color="0.649 0.701 0.701"];
	"guihua.lua" -> "go.nvim" [color="0.649 0.701 0.701" style="dashed"];
	"self-contained" -> "go.nvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "vim-fugitive" [color="0.649 0.701 0.701"];
	"self-contained" -> "diffview.nvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "rustaceanvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "suda.vim" [color="0.649 0.701 0.701"];
	"self-contained" -> "crates.nvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "markdown-preview.nvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "nvim-spectre" [color="0.649 0.701 0.701"];
	"self-contained" -> "csv.vim" [color="0.649 0.701 0.701"];
	"self-contained" -> "plenary.nvim" [color="0.649 0.701 0.701"];
	"plenary.nvim" -> "telescope-undo.nvim" [color="0.649 0.701 0.701"];
	"telescope-undo.nvim" -> "telescope.nvim" [color="0.649 0.701 0.701" style="dashed"];
	"plenary.nvim" -> "telescope.nvim" [color="0.649 0.701 0.701" style="dashed"];
	"telescope.nvim" -> "telescope-fzf-native.nvim" [color="0.649 0.701 0.701"];
	"telescope-fzf-native.nvim" -> "search.nvim" [color="0.649 0.701 0.701"];
	"search.nvim" -> "telescope-frecency.nvim" [color="0.649 0.701 0.701"];
	"telescope-frecency.nvim" -> "telescope-zoxide" [color="0.649 0.701 0.701"];
	"telescope-zoxide" -> "telescope-live-grep-args.nvim" [color="0.649 0.701 0.701"];
	"vim-rhubarb" -> "advanced-git-search.nvim" [color="0.649 0.701 0.701" style="dashed"];
	"telescope-live-grep-args.nvim" -> "advanced-git-search.nvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "sniprun" [color="0.649 0.701 0.701"];
	"fzy-lua-native" -> "wilder.nvim" [color="0.649 0.701 0.701" style="dashed"];
	"self-contained" -> "wilder.nvim" [color="0.649 0.701 0.701"];
	"self-contained" -> "nvim-tree.lua" [color="0.649 0.701 0.701"];
	"self-contained" -> "trouble.nvim" [color="0.649 0.701 0.701"];


opt [color="0.650 0.200 1.000"];
start [color="0.650 0.200 1.000"];
"self-contained" [color="0.650 0.200 1.000"];
"advanced-git-search.nvim" [color="0.650 0.200 1.000"];
"aerial.nvim" [color="0.650 0.200 1.000"];
"alpha-nvim" [color="0.650 0.200 1.000"];
"autoclose.nvim" [color="0.650 0.200 1.000"];
"bigfile.nvim" [color="0.650 0.200 1.000"];
"bufferline.nvim" [color="0.650 0.200 1.000"];
"catppuccin" [color="0.650 0.200 1.000"];
"cmp-buffer" [color="0.650 0.200 1.000"];
"cmp-latex-symbols" [color="0.650 0.200 1.000"];
"cmp-nvim-lsp" [color="0.650 0.200 1.000"];
"cmp-nvim-lua" [color="0.650 0.200 1.000"];
"cmp-path" [color="0.650 0.200 1.000"];
"cmp-spell" [color="0.650 0.200 1.000"];
"cmp-tabnine (opt)" [color="0.650 0.200 1.000" shape=doubleoctagon];
"cmp-tmux" [color="0.650 0.200 1.000"];
"cmp-treesitter" [color="0.650 0.200 1.000"];
"cmp-under-comparator" [color="0.650 0.200 1.000"];
"cmp_luasnip" [color="0.650 0.200 1.000"];
"codeium.nvim (opt)" [color="0.650 0.200 1.000" shape=doubleoctagon];
"Comment.nvim" [color="0.650 0.200 1.000"];
"copilot-cmp" [color="0.650 0.200 1.000"];
"copilot.lua" [color="0.650 0.200 1.000"];
"crates.nvim" [color="0.650 0.200 1.000"];
"csv.vim" [color="0.650 0.200 1.000"];
"diffview.nvim" [color="0.650 0.200 1.000"];
"dropbar.nvim" [color="0.650 0.200 1.000"];
"fcitx5.nvim (opt)" [color="0.650 0.200 1.000" shape=doubleoctagon];
"fidget.nvim" [color="0.650 0.200 1.000"];
"flash.nvim" [color="0.650 0.200 1.000"];
"friendly-snippets" [color="0.650 0.200 1.000"];
"fzf" [color="0.650 0.200 1.000"];
"fzy-lua-native" [color="0.650 0.200 1.000"];
"gitsigns.nvim" [color="0.650 0.200 1.000"];
"glance.nvim" [color="0.650 0.200 1.000"];
"go.nvim" [color="0.650 0.200 1.000"];
"guihua.lua" [color="0.650 0.200 1.000"];
"hop.nvim" [color="0.650 0.200 1.000"];
"indent-blankline.nvim" [color="0.650 0.200 1.000"];
"local-highlight.nvim" [color="0.650 0.200 1.000"];
"lsp-format-modifications.nvim" [color="0.650 0.200 1.000"];
"lspsaga.nvim" [color="0.650 0.200 1.000"];
"lsp_signature.nvim" [color="0.650 0.200 1.000"];
"lualine.nvim" [color="0.650 0.200 1.000"];
"LuaSnip" [color="0.650 0.200 1.000"];
"markdown-preview.nvim" [color="0.650 0.200 1.000"];
"mason-lspconfig.nvim" [color="0.650 0.200 1.000"];
"mason-null-ls.nvim" [color="0.650 0.200 1.000"];
"mason-nvim-dap.nvim" [color="0.650 0.200 1.000"];
"mason.nvim" [color="0.650 0.200 1.000"];
"mini.align" [color="0.650 0.200 1.000"];
"neoconf.nvim" [color="0.650 0.200 1.000"];
"neodim" [color="0.650 0.200 1.000"];
"neoscroll.nvim" [color="0.650 0.200 1.000"];
"none-ls.nvim" [color="0.650 0.200 1.000"];
"nui.nvim (opt)" [color="0.650 0.200 1.000" shape=doubleoctagon];
"nvim-bqf" [color="0.650 0.200 1.000"];
"nvim-bufdel" [color="0.650 0.200 1.000"];
"nvim-cmp" [color="0.650 0.200 1.000"];
"nvim-dap" [color="0.650 0.200 1.000"];
"nvim-dap-ui" [color="0.650 0.200 1.000"];
"nvim-highlight-colors" [color="0.650 0.200 1.000"];
"nvim-lspconfig" [color="0.408 0.498 1.000"];
"nvim-nio" [color="0.650 0.200 1.000"];
"nvim-notify" [color="0.650 0.200 1.000"];
"nvim-scrollview" [color="0.650 0.200 1.000"];
"nvim-spectre" [color="0.650 0.200 1.000"];
"nvim-tree.lua" [color="0.650 0.200 1.000"];
"nvim-treehopper" [color="0.650 0.200 1.000"];
"nvim-treesitter" [color="0.650 0.200 1.000"];
"nvim-treesitter-context" [color="0.650 0.200 1.000"];
"nvim-treesitter-textobjects" [color="0.650 0.200 1.000"];
"nvim-ts-autotag" [color="0.650 0.200 1.000"];
"nvim-ts-context-commentstring" [color="0.650 0.200 1.000"];
"nvim-web-devicons" [color="0.650 0.200 1.000"];
"paint.nvim" [color="0.650 0.200 1.000"];
"persisted.nvim" [color="0.650 0.200 1.000"];
"plenary.nvim" [color="0.650 0.200 1.000"];
"project.nvim" [color="0.650 0.200 1.000"];
"rainbow-delimiters.nvim" [color="0.650 0.200 1.000"];
"rustaceanvim" [color="0.650 0.200 1.000"];
"search.nvim" [color="0.650 0.200 1.000"];
"smart-splits.nvim" [color="0.650 0.200 1.000"];
"smartyank.nvim" [color="0.650 0.200 1.000"];
"sniprun" [color="0.650 0.200 1.000"];
"suda.vim" [color="0.650 0.200 1.000"];
"telescope-frecency.nvim" [color="0.650 0.200 1.000"];
"telescope-fzf-native.nvim" [color="0.650 0.200 1.000"];
"telescope-live-grep-args.nvim" [color="0.650 0.200 1.000"];
"telescope-undo.nvim" [color="0.650 0.200 1.000"];
"telescope-zoxide" [color="0.650 0.200 1.000"];
"telescope.nvim" [color="0.650 0.200 1.000"];
"todo-comments.nvim" [color="0.650 0.200 1.000"];
"toggleterm.nvim" [color="0.650 0.200 1.000"];
"trouble.nvim" [color="0.650 0.200 1.000"];
"vim-cool" [color="0.650 0.200 1.000"];
"vim-fugitive" [color="0.650 0.200 1.000"];
"vim-matchup" [color="0.650 0.200 1.000"];
"vim-rhubarb" [color="0.650 0.200 1.000"];
"vim-sleuth" [color="0.650 0.200 1.000"];
"which-key.nvim" [color="0.650 0.200 1.000"];
"wilder.nvim" [color="0.650 0.200 1.000"];

BufReadPre [color="0.590 0.273 1.000"];
BufWinEnter [color="0.590 0.273 1.000"];
BufReadPost [color="0.590 0.273 1.000"];
BufAdd [color="0.590 0.273 1.000"];
InsertEnter [color="0.590 0.273 1.000"];
VeryLazy [color="0.590 0.273 1.000"];
BufNewFile [color="0.590 0.273 1.000"];
LspAttach [color="0.590 0.273 1.000"];
CursorHold [color="0.590 0.273 1.000"];
CursorHoldI [color="0.590 0.273 1.000"];
}
```
</details>

## Scopes

### Completion

- **neovim/nvim-lspconfig**: Neovim's native LSP configuration
  - **williamboman/mason.nvim**: package manager for LSP, DAP servers, linters and formatters
  - **williamboman/mason-lspconfig.nvim**: using `nvim-lspconfig` with `mason.nvim`
  - **folke/neoconf.nvim**: used for managing global and project-local settings
  - **Jint-lzxy/lsp_signature.nvim**: show signature when completing function parameters
- **glepnir/lspsaga.nvim**: better LSP functions
  - **nvim-tree/nvim-web-devicons**: nerdfont source
- **stevearc/aerial.nvim**: a code outline window for skimming and quick navigation
- **DNLHC/glance.nvim**: previewing, navigating and editing LSP locations in one place
- **joechrisellis/lsp-format-modifications.nvim**: partially format modified code
- **nvimtools/none-ls.nvim**: use Neovim as a language server via Lua
  - **nvim-lua/plenary.nvim**: Lua function collections
  - **jay-babu/mason-null-ls.nvim**: using `null-ls` with `mason.nvim`
- **hrsh7th/nvim-cmp**: auto completion plugin for Neovim

  - **L3MON4D3/LuaSnip**: snippets completion engine for `nvim-cmp`
    - **rafamadriz/friendly-snippets**: snippets source for `LusSnip`
  - **lukas-reineke/cmp-under-comparator**: better completion sorting for underline items in `nvim-cmp`
  - **saadparwaiz1/cmp_luasnip**: luasnip source for `nvim-cmp`
  - **hrsh7th/cmp-nvim-lsp**: lsp source for `nvim-cmp`
  - **hrsh7th/cmp-nvim-lua**: lua source for `nvim-cmp`
  - **andersevenrud/cmp-tmux**: tmux source for `nvim-cmp`
  - **hrsh7th/cmp-path**: path source for `nvim-cmp`
  - **f3fora/cmp-spell**: spell source for `nvim-cmp`
  - **hrsh7th/cmp-buffer**: buffer source for `nvim-cmp`
  - **kdheepak/cmp-latex-symbols**: latex symbols source for `nvim-cmp`
  - **ray-x/cmp-treesitter**: treesitter source for `nvim-cmp`

- **zbirenbaum/copilot.lua**: lua port of `copilot.vim`
  - **zbirenbaum/copilot-cmp**: copilot source for `nvim-cmp`

### Editor

- **olimorris/persisted.nvim**: session management
- **m4xshen/autoclose.nvim**: auto pairs & closes brackets
- **LunarVim/bigfile.nvim**: provide support for editing large files
- **ojroques/nvim-bufdel**: close buffer gently with `bufferline.nvim`
- **folke/flash.nvim**: navigate your code with search labels, enhanced character motions, and Treesitter integration
- **numToStr/Comment.nvim**: better comment
- **sindrets/diffview.nvim**: git diff view
- **echasnovski/mini.align**: align text interactively
- **smoka7/hop.nvim**: better motion jumping
- **tzachar/local-highlight.nvim**: highlights uses of word under cursor within viewing window
- **brenoprata10/nvim-highlight-colors**: highlight colors
- **romainl/vim-cool**: auto-clear highlight after search
- **lambdalisue/suda.vim**: allows one to edit a file with prevledges from an unprivledged session
- **tpope/vim-sleuth**: automatically adjusts `shiftwidth` and `expandtab` based on current file
- **nvim-pack/nvim-spectre**: find and replace on project-based
- **mrjones2014/smart-splits.nvim**: combind navigation and resizing of Neovim and terminal multiplexer splits
- **nvim-treesitter/nvim-treesitter**: super powerful code highlighter
  - **andymass/vim-matchup**: better matchup for `%`
  - **mfussenegger/nvim-treehopper**: select textobject like `hop.nvim`
  - **nvim-treesitter/nvim-treesitter-textobjects**: move between textobjects
  - **windwp/nvim-ts-autotag**: faster `vim-closetag`
  - **nvim-treesitter-context**: shows the context of the currently visible buffer contents
  - **JoosepAlviste/nvim-ts-context-commentstring**: context-based comment

### Lang

- **kevinhwang91/nvim-bqf**: better quick fix
- **ray-x/go.nvim**: plugin for golang
- **mrcjkb/rustaceanvim**: plugin for rust
- **Saecki/crates.nvim**: manage `crates.io` dependencies
- **iamcco/markdown-preview.nvim**: render markdown preview
- **chrisbra/csv.vim**: plugin for csv

### Tool

- **tpope/vim-fugitive**: git operations inside Neovim, by legendary tpope
- **Bekaboo/dropbar.nvim**: winbar breadcrumbs
- **nvim-tree/nvim-tree.lua**: better `netrw`
- **ibhagwan/smartyank.nvim**: provide tmux/OSC52 clipboard support
- **michaelb/sniprun**: run code snippet quickly
- **akinsho/toggleterm.nvim**: better terminal
- **folke/trouble.nvim**: show code errors
- **folke/which-key.nvim**: keymap hints
- **gelguy/wilder.nvim**: command mode completions
  - **romgrk/fzy-lua-native**: `fzy` support for `wilder.nvim`
- **nvim-telescope/telescope.nvim**: general fuzzy filder
  - **nvim-lua/plenary.nvim**: required by `telescope.nvim`
  - **nvim-tree/nvim-web-devicons**: nerd font icons
  - **jvgrootveld/telescope-zoxide**: jump to directory recorded by `zoxide`
  - **debugloop/telescope-undo.nvim**: fuzzy find undo history
  - **nvim-telescope/telescope-frecency.nvim**: frequent and recent file jump
  - **nvim-telescope/telescope-live-grep-args.nvim**: supprt args when using `live_grep`
  - **nvim-telescope/telescope-fzf-native.nvim**: `fzf` search
  - **FabianWirth/search.nvim**: all-in-one telescope collections panel
  - **ahmedkhalf/project.nvim**: manage projects
  - **aaronhallaert/advanced-git-search.nvim**: fuzzy-finding git stuffs
    - **tpope/vim-rhubarb**: github extension for vim-fugitive
    - **tpope/vim-fugitive**: git wrapper
    - **sindrets/diffview.nvim**: show diffview for git
- **mfussenegger/nvim-dap**: Debug Adapter Protocol client implementation for Neovim
  - **rcarriga/nvim-dap-ui**: UI for DAP
    - **nvim-neotest/nvim-nio**: A library for asynchronous IO
  - **jay-babu/mason-nvim-dap.nvim**: bridges `mason.nvim` and `nvim-dap`

### UI

- **goolord/alpha-nvim**: better startup page
- **akinsho/bufferline.nvim**: tab and buffer management
- **Jint-lzxy/nvim**: catppuccin theme
- **j-hui/fidget.nvim**: show lsp real-time status
- **lewis6991/gitsigns.nvim**: show git status in `statuscolum`
- **lukas-reineke/indent-blankline.nvim**: show indent with different level
- **nvim-lualine/lualine.nvim**: minimal, fast but customizable `statusline`
- **zbirenbaum/neodim**: dimming the unused symbols
- **karb94/neoscroll.nvim**: smooth scroll
- **rcarriga/nvim-notify**: animated notify
- **folke/paint.nvim**: easily add additional highlights to buffers
- **folke/todo-comments.nvim**: highlight certain keywords in commnets
- **dstein64/nvim-scrollview**: scroll-able scrollbar
