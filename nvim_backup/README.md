# 我的 Neovim 配置

这是此 Neovim 设置中插件和功能的摘要。

## 参考资源

- [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md): 提供LSP配置的文档。
- **Dotfile**:
  - [1](https://github.com/craftzdog/dotfiles-public)：主要包含TypeScript和JavaScript的配置。
  - [2](https://github.com/ayamir/nvimdots)：知乎大佬的配置。

## 配置文件说明

- **`init.lua`**: Neovim 的主配置文件，加载其他 Lua 模块。
- **`lua`**:
  - `config`: `lazy.nvim`管理器配置
  - `plugins.lua`: 插件列表和配置
  - `plugins`: 自定义插件配置
    - `lsp-config`: LSP支持，参考[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)进行修改。

## 插件管理器

- **[lazy.nvim](https://github.com/folke/lazy.nvim)**: 一个现代且快速的 Neovim 插件管理器。

## 核心插件

### 用户界面与外观

- **[alpha-nvim](https://github.com/goolord/alpha-nvim)**: 一个美观且可配置的启动屏幕/仪表板。
- **[catppuccin](https://github.com/catppuccin/nvim)**: 一个柔和的马卡龙色系主题。
  - 备用：[folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim): 蓝色系，日系风格
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**: 一个快速且可定制的状态行。
- **[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)**: 一个文件浏览器树，可以替代 NERDTree。
- **[nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)**: 为 neo-tree 和 telescope 等插件添加文件类型图标。

### 功能性

- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**: 一个高度可扩展的模糊查找器，用于快速定位文件、缓冲区、LSP 定义等。
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: 提供高级语法高亮、缩进和其他语言感知功能。
- **[folke/which-key.nvim](https://github.com/folke/which-key.nvim)**: 显示当前可用的按键绑定。
- **[nvim-neorg/neorg](https://github.com/nvim-neorg/neorg)**: 组织和管理笔记的插件。
- **[leetcode](https://github.com/kawre/leetcode.nvim)**: 提供 LeetCode 题目的浏览和解答功能。

### 编码辅助 (LSP 与补全)

- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**: 一个用于配置 Neovim 内置 LSP 客户端的辅助插件。
- **[mason.nvim](https://github.com/williamboman/mason.nvim)**: 管理 LSP 服务器、linter 和 formatter 的安装，例如用于 C++ 的 `clangd` 和用于 Python 的 `pyright`。
- **[mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)**: 一个桥接插件，使 `mason.nvim` 和 `nvim-lspconfig` 无缝协作。
- **[copilot.vim](https://github.com/github/copilot.vim)**: 提供 GitHub Copilot 的 AI 驱动代码补全。
- **[hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**: 一个强大的补全插件，支持 LSP、SnipMate 和其他源。

### 依赖项

- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)**: 一个实用程序库，被许多其他插件（如 Telescope）使用。
- **[nui.nvim](https://github.com/MunifTanjim/nui.nvim)**: 一个 UI 组件库，也是其他插件的依赖项。