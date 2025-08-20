通过 `:Tutor dots` 来了解此配置！

## 通用设置

所有常用条目都已在 [settings.lua](https://github.com/ayamir/nvimdots/blob/main/lua/core/settings.lua) 中实现。

## 结构

init.lua 是配置的根文件。它会加载 lua 目录内的配置。

- lua 目录包含 4 个部分。

  - `core` 目录包含 neovim 的基础配置。

  - `keymap` 目录包含插件的键位绑定。

  - `modules` 目录包含三个主要的子文件夹。

    - `plugins/{scope}.lua` 包含相应范围内的插件。详见下文。

    - `configs/{scope}/` 目录根据给定的范围包含插件设置。

    - `utils/icons.lua` 包含用于插件设置的图标。详见下文。

    - `utils/dap.lua` 包含几个用于 DAP 配置文件最常用的函数。

    - `utils/keymap.lua` 包含用于键位重映射的辅助函数。不建议直接使用。

    - `utils/init.lua` 包含插件使用的工具函数。详见下文。

    - **{scope} (范围) 定义**
      - `completion` 包含用于代码补全的插件。

      - `editor` 包含增强原生 `nvim` 默认能力的插件。

      - `lang` 包含与特定编程语言相关的插件。

      - `tool` 包含使用外部工具并改变默认布局、为 `nvim` 提供新能力的插件。

      - `ui` 包含在用户启动 `nvim` 后渲染界面且无需任何操作的插件。

  - `user` 目录包含用户自定义配置。

    - `plugins/{scope}.lua` 包含用户添加的（自定义）插件，按范围划分。
    - `configs/{plugin-name}.lua` 使用插件的基础配置文件名来覆盖默认插件设置。
    - `configs/` 目录根据范围包含用户添加的插件设置。
      - `dap-clients/` 目录包含 DAP 客户端的设置。
      - `lsp-servers/` 目录包含 LSP 服务器的设置。

    - `keymap/` 目录包含自定义键位绑定。
    - `event.lua` 包含自定义用户事件。
    - `options.lua` 包含对原生 `nvim` 选项的覆盖。
    - `settings.lua` 包含对设置的覆盖。

- `modules` 目录的默认（或基础）文件树如下：

```console
init.lua
   └── lua/
       └── modules/
           ├── plugins/
           │   ├── completion.lua
           │   ├── editor.lua
           │   ├── lang.lua
           │   ├── tool.lua
           │   └── ui.lua
           ├── configs/
           │   ├── completion/
           │   ├── editor/
           │   ├── lang/
           │   ├── tool/
           │   └── ui/
           └── utils/
               ├── dap.lua
               ├── icons.lua
               ├── keymap.lua
               └── init.lua
```

## 如何根据你的偏好进行自定义

### 关于用户覆盖（设置、选项、事件等）
> **注意：**
> - user 在 `require` 的搜索路径中（[见此](https://github.com/ayamir/nvimdots/blob/647c23f9973fbb4a1228948afeb792e15b8c04a0/lua/core/pack.lua#L26-L34)）。因此，例如，你应该使用 `configs.editor` 而不是 `user.configs.editor`。
> - 如果你想了解更多实现细节，[#888](https://github.com/ayamir/nvimdots/issues/888)、[#972](https://github.com/ayamir/nvimdots/issues/972) 和 [#973](https://github.com/ayamir/nvimdots/pull/973) 中的讨论可能会对你有所帮助。

总的来说，我们有一个自定义的用户配置加载器，它会尊重你的偏好（这意味着它会与基础配置 _合并_ 或 _覆盖_ 基础配置）。它具有以下特点：
- 如果要合并的基础表中存在相应的键，它总是会替换该值。
- 如果表中不存在该键，它总是会追加（键，值）对。
- 如果现有表是嵌套表，它的行为如下：

  - 如果用户提供一个表（table），
    - 如果嵌套表是列表（list），它总是追加给定的值（并忽略键）；
    - 如果嵌套表是字典（dictionary），它总是更新相应的值或追加（键，值）对。
  - 如果用户提供一个函数（function），
    - 它会完全替换目标表，无论是否嵌套。

例如，如果 `lsp_deps` 的默认设置是：

```lua
settings["lsp_deps"] = {
	"bashls",
	"clangd",
	"html",
	"jsonls",
	"lua_ls",
	"pylsp",
}
```

你可以通过 `user/settings.lua` 像下面这样调整配置：

- 合并条目

```lua
settings["lsp_deps"] = {
	"zls", -- zig lsp
}
--[[
结果会是：
  {
    "bashls",
    "clangd",
    "html",
    "jsonls",
    "lua_ls",
    "pylsp",
    "zls"
  }
--]]
```

- 覆盖条目

```lua
settings["lsp_deps"] = function(defaults)
	return {
		defaults[5], -- "lua_ls"
		defaults[6], -- "pylsp"
		"zls", -- zig lsp
	}
end
--[[
结果会是：
  {
    "lua_ls",
    "pylsp",
    "zls"
  }
--]]
```

请注意，底层实现 (`load_plugin()`) 总是将 `defaults` 表作为第一个参数传递给你的函数。
即：

```lua
-- 通过 user/configs/bufferline.lua 调整 bufferline.lua
return function(defaults)
	 return {
	 	 options = {
	 	 	 number = nil,
			-- 其他配置...
	 	 	 color_icons = defaults.options.color_icons, -- 引用基础配置
		}
	}
end
```

### 覆盖现有插件 `lazy.nvim` 相关配置的步骤

1. 在 `user/plugins/<scope>.lua` 中设置你的配置。

示例：在 `user/plugins/editor.lua` 中为 `olimorris/persisted.nvim` 设置 `lazy = false`。
```lua
editor["olimorris/persisted.nvim"] = {
	lazy = false,
}
```

### 修改插件配置的步骤

1. 检查插件是用 lua 编写还是用 `Vimscript` 编写。

2. 在 `user/configs/<plugin-name>.lua` 中添加一个新条目。注意，该文件名必须与 `lua/modules/configs/<scope>/` 中定义的父规范（parent spec）同名。

3. 如果你的插件是用 lua 编写的，通过以下方式覆盖它：_（见下文示例）_

   - 如果你只想替换 `modules/configs/<scope>/<plugin-name>.lua` 中定义的 _部分_ 基础配置，则返回一个表（table）。

   - 如果你想 _完全_ 替换 `modules/configs/<scope>/<plugin-name>.lua` 中定义的基础配置，则返回一个函数（function）。

   - 如果你不想调用 `setup` 函数（即，你想使用插件的默认选项），则返回 `false`。

4. 如果你的插件是用 `Vimscript` 编写的，通过以下方式覆盖它：_（见下文示例）_

- 返回一个包含 `vim.g.<options> = foobar` 序列的函数。

示例：（如果插件是用 lua 编写的）：

- `user/configs/telescope.lua`

  - 通过 `return` 一个表来更新值或添加（键，值）对。

  ```lua
  return {
  	defaults = {
  		mappings = {
  			n = {
  				["q"] = "close",
  			},
  		},
  	},
  }
  ```

  - 通过 `return` 一个函数来完全替换默认值。

  ```lua
  return {
  	defaults = function()
  		return {
  			mappings = {
  				n = {
  					["q"] = "close",
  				},
  			},
  		}
  	end,
  }
  ```

示例（如果插件是用 `VimScript` 编写的）：

- `user/configs/vim-go.lua`

```lua
return function()
	vim.g.go_doc_keywordprg_enabled = 1
end
```

### 添加新插件的步骤

1. 在 `user/configs/` 下创建一个名为 `<scope>` 的子目录，并在 `plugins/` 下创建一个名为 `<scope>.lua` 的文件。`<scope>.lua` 应包含以下初始内容：
> **注意：** 这里我们为用户配置采用与 configs 类似的结构。

```lua
local custom = {}

return custom
```

2. 按照 `plugins/` 和 `configs/` 中其他插件的配置格式添加这个新插件。具体来说：

   - 在 `user/plugins/<scope>.lua` 中添加一个新条目 _（见下文示例）_

   - 在 `user/configs/<scope>` 下创建一个以插件名为文件名的新 `.lua` 文件 _（文件名可以略有不同，只要你能理解即可）_。

示例：

- `user/plugins/editor.lua`

```lua
local custom = {}

custom["folke/todo-comments.nvim"] = {
	lazy = true,
	event = "BufRead",
	config = require("configs.editor.todo-comments"), -- 加载该配置
}

return custom
```

- `user/configs/editor/todo-comments.lua`

```lua
return function() -- 此文件必须返回一个不接受参数且无返回值的函数
	require("todo-comments").setup()
end
```

如果你想添加一个带有修改配置的 VimScript 插件，你应该使用 `init` 而不是 `config`。例如：

- `user/plugins/editor.lua`

```lua
local editor = {}
editor["mg979/vim-visual-multi"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
        -- 使用 init 而不是 config
	init = require("configs.editor.visual-multi"),
}
return editor
```

- `user/configs/editor/visual-multi.lua`

```lua
return function()
	vim.g.VM_default_mappings = 0
	vim.g.VM_maps = {
		["Find Under"] = "<C-x>",
		["Find Subword Under"] = "<C-x>",
	}
	vim.g.VM_mouse_mappings = 1
end
```

### 完整示例
让我们将上述步骤应用于一个实际情况：

- 我想修改 `specs.nvim` 的设置 (`modules/configs/ui/specs.lua`)：

我们有如下的基础规范（spec） (`specs.lua`)：
```lua
return function()
	require("modules.utils").load_plugin("specs", {
		show_jumps = true,
		min_jump = 10,
		popup = {
			delay_ms = 0, -- 弹窗显示前的延迟
			inc_ms = 10, -- 用于淡入/淡出和调整大小效果的时间增量
			blend = 10, -- 初始混合度，介于 0-100（完全透明）之间，见 :h winblend
			width = 10,
			winhl = "PmenuSbar",
			fader = require("specs").pulse_fader,
			resizer = require("specs").shrink_resizer,
		},
		ignore_filetypes = {},
		ignore_buftypes = { nofile = true },
	})
end
```

1. 创建 `user/configs/specs.lua`；

2.1. **我想将 `popup.delay_ms` 设置为 20**：
```lua
-- 其他配置... (新的 autocmds, usercmds 等)

return {
	popup = {
		delay_ms = 20,
	}
}
```
`load_plugin` 会将此规范与父规范合并，然后调用 `require("specs").setup({final_spec})`

2.2. **我想自己定制这个插件**：
```lua
return function(defaults) -- 这是父规范，以备你需要参考
	-- 其他配置... (新的 autocmds, usercmds 等)

	defaults.show_jumps = true
	-- 或者 (完全替换) --
	defaults = { show_jumps = true }

	-- 最后... --
	return defaults
end

-- 或者你也可以这样做 --

return function()
	return { show_jumps = true }
end
```
而 `load_plugin` 则会执行：`require("specs").setup({opts})`

或者你可以通过返回一个调用 `require("specs").setup({})` 的函数来完全替换配置

```lua
return function()
    require("specs").setup({
         -- opts
    })
end
```

**不要在你的覆盖文件中调用 `load_plugin`，这会导致无限递归调用然后栈溢出。**

2.3 **我想使用插件的默认选项**：
```lua
return false
```

- 我想添加一个新插件：

添加插件就像在 `user/plugins/*.lua` 下的某个文件中添加插件规范一样简单。你可以在那里创建任意数量的文件。

你可以为每个插件创建一个文件来组织你的 plugins 文件夹，或者用一个单独的文件包含某个功能的所有插件规范。示例：
```lua
return {
	-- 添加 symbols-outline
	["simrat39/symbols-outline.nvim"] = {
	 	 lazy = true,
	 	 cmd = "SymbolsOutline",
	 	 opts = {
			-- 在这里添加应传递给 setup() 函数的选项
	 	 	 position = "right",
		},
		-- 或者 --
	 	config = function()
			-- 自己设置插件
	 	 end
		-- 或者 --
	 	config = require("configs.symbolsoutline") -- 这也行
	},
}
```

_（如果你需要帮助，随时可以提一个 issue。）_

### 禁用插件的步骤

1. 在 `user/settings.lua` 中，将插件的完整（仓库）名称添加到 `settings["disabled_plugins"]`。

> **注意**：如果你想使用一个 fork 的仓库，你无需将原始仓库添加到 `disabled_plugins`，见 [#1077](https://github.com/ayamir/nvimdots/issues/1077) 和 [#1079](https://github.com/ayamir/nvimdots/pull/1079)。

示例：

- `lua/settings.lua`

```lua
-- 禁用以下两个插件
settings["disabled_plugins"] = {
	"karb94/neoscroll.nvim",
	"dstein64/nvim-scrollview",
}
```

### 修改键位映射

- 对于原生 `nvim` 键位映射

  修改 `user/keymap/core.lua`

- 对于特定插件的键位映射

  修改 `user/keymap/<scope>.lua`

- 命令分解

  ```lua
      ┌─ 分隔符  ┌── 映射类型
   ["n|gb"] = map_cr("BufferLinePick"):with_noremap():with_silent(),
     │  └── 映射键           │              └── 特殊选项    │
     └──── 映射模式         └── 映射内容                     └── 特殊选项 (可链式调用)
  ```

- 将值设置为空或 `false` 以移除基础键位映射。

示例

- `user/keymap/ui.lua`

```lua
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {
	-- 移除默认键位映射
	["n|<leader>nf"] = "",
	["n|<leader>nr"] = false,
	-- 插件: telescope
	["n|<leader><S-cr>"] = map_callback(function()
			_command_panel()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("tool: Toggle command panel"),
}
```

### 修改 LSP、代码检查工具和格式化工具

- 添加/移除语言服务器协议 (LSP) 服务器

  修改 `user/settings` -> `settings[lsp_deps]`，你可以在[这里](https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations)找到可用的源。然后在 `user/configs/lsp-servers` 中添加一个服务器配置文件，关于如何配置服务器，请参阅 `lua/modules/configs/completions/servers/`，你可以参考其他服务器的配置文件。重启 `nvim` 以安装新的 LSP 服务器。

  **注意**：一些 LSP 在安装运行时包时已经附带。例如 `dartls` 在安装 `dart` 运行时附带，所以用户在调用 `:Mason` 时不会看到这些 LSP，见 [#525](https://github.com/ayamir/nvimdots/pull/525)。

- 添加/移除代码检查工具（linter）和格式化工具（formatter）

  修改 `user/settings` -> `settings[null_ls_deps]`，你可以在[这里](https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins)找到可用的源。如果你想改变特定 `null-ls` 源的行为，在 `user/configs/null-ls.lua` -> `sources` 表中设置额外的参数。_（见下文示例）_ 重启 `nvim` 以安装新的 `null-ls` 源。

示例

- `user/configs/null-ls.lua`

```lua
local null_ls = require("null-ls")
local btns = null_ls.builtins

return {
	sources = {
		btns.formatting.black.with({
			filetypes = { "python" },
			extra_args = { "--fast", "-q", "-l", "120", "extend-ignore = E203, E501" },
		}),
	},
}
```

**注意**：一些代码检查工具和格式化工具在安装运行时包时已经附带。例如 `dart_format` 在安装 `dart` 运行时附带，所以用户在调用 `:Mason` 时不会看到这些格式化工具。只需在 `settings[null_ls_deps]` 表中设置 `dart_format`，`mason-null-ls` 就会为你设置好，更多信息见 [#525](https://github.com/ayamir/nvimdots/pull/525)。

- 改变格式化工具的全局行为

  - 在特定文件类型上禁用格式化

    修改 `user/settings` -> `settings[formatter_block_list]`。

  - 在特定 LSP 服务器上禁用格式化能力

    修改 `user/settings` -> `settings[server_formatting_block_list]`。

  - 定义额外的 <formatter> 参数

    在 formatters 下创建一个名为 `<formatter_name>.lua` 的文件，并返回一个包含参数的表。

    例如：在 formatters 下创建一个名为 `clang_format.lua` 的文件，并填入内容 `return {"-style=file"}`。（然后 `clang_format` 将会遵循项目根目录下的格式化相关文件，如 `.clang-format`。）

- 改变 LSP 服务器和代码检查工具的行为

  - 创建并编辑 `user/configs/lsp-servers/<server-name>.lua`。
  - 参阅 `lua/modules/configs/completions/servers/`。

### 修改 DAP 客户端

- 添加/移除调试适配器协议 (DAP) 客户端
  修改 `user/settings` -> `settings[dap_deps]`，你可以在[这里](https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua)找到可用的源。然后在 `user/configs/dap-clients` 中添加一个客户端配置文件，关于如何配置 dap 客户端，请参阅 clients，你可以参考其他客户端的配置文件。重启 `nvim` 以安装新的 DAP 客户端。

### 修改由 `autocmd` 定义的事件

- 修改 `user/event.lua`

- 可用的键请参阅 `lua/core/events.lua`。

示例

- `user/events.lua`

```lua
local definitions = {
	-- 示例
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
	},
}

return definitions
```

### 修改原生 `nvim` 选项

- 修改 `user/options.lua`

- 全局选项直接列出。

示例

- `user/options.lua`

```lua
vim.g.editorconfig = 0
local options = {
	autoindent = true,
}

return options
```

### 修改设置

- 修改 `user/settings.lua`。

- 键和对应的有效值请参阅 settings.lua。

示例

- `user/settings.lua`

```lua
local settings = {}

-- 示例
settings["use_ssh"] = true

settings["colorscheme"] = "catppuccin"

return settings
```

### 切换 `colorscheme` (配色方案)

- 在 `user/settings.lua` 中修改 `colorscheme` 的值。

```lua
-- 例如，将配色方案设置为 catppuccin-latte
settings["colorscheme"] = "catppuccin-latte"
```

**注意**：`lualine` 的 `colorscheme` 也会根据当前 `nvim` 的 `colorscheme` 而改变。如果你对此感兴趣，请参阅 lualine.lua 中的 `custom_theme` 函数。

所有修改过的配置在你重启 `nvim` 后都会生效。

## 全局资源

### 调色板

此配置提供了一个全局统一的调色板。你可以使用 `require("modules.utils").get_palette({ <color_name> = <hex_value> }?)` 来获取全局调色板。特定颜色可以在 [settings.lua](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/core/settings.lua#L18-L23) 中覆盖，或者作为函数参数传入。输入时你将获得参数补全。

修改调色板的优先级顺序是：

```
预设颜色 < 在 `settings.lua` 中定义的全局颜色 < 传入的函数参数
```

所有可用的颜色可以在[这里](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/utils/init.lua#L3-L30)找到。你也可以在该文件中探索实现细节。

### 图标

此配置还提供了一个专用的图标集。可以通过 `require("modules.utils.icons").get(category, add_space?)` 访问。输入时你将获得参数补全。

你可以在[这里](https://github.com/ayamir/nvimdots/blob/main/lua/modules/utils/icons.lua)找到图标列表。

## 操作手册

- 查找单词

[![hop to find word](https://s2.loli.net/2022/01/06/WZKjvaF8qGEYP5R.png)](https://youtu.be/Otz09Gdk4NA)

- 区域操作

[![region operation](https://s2.loli.net/2022/01/06/PzcmOIksQNbeEpA.png)](https://youtu.be/4esdUMHXNTo)

## 如何使用 catppuccin 配色方案指南

### 什么是 Catppuccin？ <sup><a href="https://www.reddit.com/r/neovim/comments/r9619t/comment/hna3hz8">[[1]](https://www.reddit.com/r/neovim/comments/r9619t/comment/hna3hz8)</a></sup>

> Catppuccin 是一个社区驱动的舒缓柔和色调主题，旨在成为低对比度和高对比度主题之间的中间地带，提供一个温暖的调色板，包含 26 种悦目的颜色，这些颜色在白天足够明亮可见，而在夜晚又足够柔和，对眼睛友好。

### 基本用法

修改[这些行](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/catppuccin.lua#L2-L89)。_（注意：此链接可能与 `HEAD` 略有不同，但可作为参考。）_ 每个选项的详细解释见下文。

#### 通用

这些设置与任何组无关，是全局独立的。

- `flavour`: _（可以是 `latte`, `frappe`, `macchiato`, 或 `mocha` 中的任意一个）_ 这是**强制性**的。你**必须**设置此值才能使 catppuccin 正常工作。注意 `latte` 是一个浅色方案，其余是深色方案；`mocha` 调色板是唯一被修改过的，以使 catppuccin 看起来像 v0.1 版本。详情请查看[此 PR](https://github.com/ayamir/nvimdots/pull/163)。
- `transparent_background`: _（布尔值）_ 如果为 true，则禁用设置背景色。
- `term_colors`: _（布尔值）_ 如果为 true，则设置终端颜色（即 `g:terminal_color_0`）。

#### 暗化非活动窗口

此设置管理使**非活动**的分屏/窗口/缓冲区变暗的能力。

- `enabled`: _（布尔值）_ 如果为 true，则使非活动窗口或缓冲区的背景色变暗。
- `shade`: _（字符串）_ 设置应用于非活动分屏或窗口或缓冲区的阴影。
- `percentage`: _（0 到 1 之间的数字）_ 应用于非活动窗口、分屏或缓冲区的阴影百分比。

#### 样式

处理通用高亮组的样式 _（详细解释见 `:h highlight-args`）_：

- `comments`: _（表）_ 改变注释的样式。
- `functions`: _（表）_ 改变函数的样式 _（例如，配置中的[按钮](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/alpha.lua#L28)）_。
- `keywords`: _（表）_ 改变关键字的样式 _（例如，`local`）_。
- `strings`: _（表）_ 改变字符串的样式。
- `variables`: _（表）_ 改变变量的样式。
- `properties`: _（表）_ 改变仅有 getter 和/或 setter 的虚字段的样式 _（例如，字段访问 `tbl.field`）_。
- `operators`: _（表）_ 改变操作符的样式。
- `conditionals`: _（表）_ 改变条件检查关键字的样式 _（例如，`if`）_。
- `loops`: _（表）_ 改变循环关键字的样式 _（例如，`for`）_。
- `booleans`: _（表）_ 改变布尔值的样式。
- `numbers`: _（表）_ 改变数字的样式。
- `types`: _（表）_ 改变类型的样式 _（例如，`int`）_。

#### 集成

这些集成允许 catppuccin 设置各种插件的主题。要启用一个集成，你需要将其设置为 `true`。

#### 使用自动编译功能

> Catppuccin 是一个高度可定制和可配置的配色方案。然而，这是以复杂性和执行时间为代价的。

Catppuccin 可以预先计算配置结果并将结果存储在一个已编译的 lua 文件中。这些预缓存的值稍后用于设置高亮。缓存文件默认存储在 `vim.fn.stdpath("cache") .. "/catppuccin"` _（使用 `:lua print(vim.fn.stdpath("cache") .. "/catppuccin")` 查看它在你的计算机上的位置）_。你可以通过修改[此行](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/catppuccin.lua#L17)来改变此行为。

> **注意**：自 2022 年 7 月 10 日起，当 setup 表发生变化时，catppuccin 应该能够自动重新编译。你无法禁用此功能。

### 高级功能

#### 自定义调色板

不满意当前的外观？你可以像 `mocha` 那样自己修改调色板！

#### 获取 catppuccin 颜色

```lua
local latte = require("catppuccin.palettes").get_palette "latte"
local frappe = require("catppuccin.palettes").get_palette "frappe"
local macchiato = require("catppuccin.palettes").get_palette "frappe"
local mocha = require("catppuccin.palettes").get_palette "mocha"

local colors = require("catppuccin.palettes").get_palette() -- 当前风味的调色板
```

这些行将分别返回一个表，其中键是颜色名称，值是其十六进制值。

#### 覆盖高亮组

全局高亮组可以像这样被覆盖：

```lua
custom_highlights = function(cp)
	return {
		<hl_group> = { <fields> }
	}
end
```

这是一个例子：

```lua
require("catppuccin").setup({
	custom_highlights = function(cp)
		return {
			Comment = { fg = cp.flamingo },
			["@constant.builtin"] = { fg = cp.peach, style = {} },
			["@comment"] = { fg = cp.surface2, style = { "italic" } },
		}
	end,
})
```

每个风味的高亮组可以从[此行](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/catppuccin.lua#L121)开始像这样被覆盖：

```lua
highlight_overrides = {
	all = function(cp) -- 全局高亮，如果存在 custom_highlights 则会被替换
		return {
			<hl_group> = { <fields> }
		}
	end, -- 每个风味都一样
	latte = function(latte) end,
	frappe = function(frappe) end,
	macchiato = function(macchiato) end,
	mocha = function(mocha) end,
}
```

这是一个例子：

```lua
local ucolors = require("catppuccin.utils.colors")
require("catppuccin").setup({
	highlight_overrides = {
		all = function(colors)
			return {
				NvimTreeNormal = { fg = colors.none },
				CmpBorder = { fg = "#3E4145" },
			}
		end,
		latte = function(latte)
			return {
				Normal = { fg = ucolors.darken(latte.base, 0.7, latte.mantle) },
			}
		end,
		frappe = function(frappe)
			return {
				["@comment"] = { fg = frappe.surface2, style = { "italic" } },
			}
		end,
		macchiato = function(macchiato)
			return {
				LineNr = { fg = macchiato.overlay1 },
			}
		end,
		mocha = function(mocha)
			return {
				Comment = { fg = mocha.flamingo },
			}
		end,
	},
})
```

此外，如果你想稍后加载其他自定义高亮，可以使用此函数：

```lua
require("catppuccin.lib.highlighter").syntax()
```

例如：

```lua
local colors = require("catppuccin.palettes").get_palette() -- 从调色板获取颜色
require("catppuccin.lib.highlighter").syntax({
	Comment = { fg = colors.surface0 }
})
```

> **注意**：使用 `require("catppuccin.lib.highlighter").syntax()` 函数加载的自定义高亮**不会**被预编译。
>
> 与可以更新高亮组的 `:highlight` 命令不同，此函数完全替换定义。（`:h nvim_set_hl`）

#### 覆盖颜色

颜色可以使用 `color_overrides` 从[此行](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/catppuccin.lua#L90)开始覆盖，像这样：

```lua
require("catppuccin").setup {
	color_overrides = {
		all = {
			text = "#FFFFFF",
		},
		latte = {
			base = "#FF0000",
			mantle = "#242424",
			crust = "#474747",
		},
		frappe = {},
		macchiato = {},
		mocha = {},
	}
}
```

#### 想知道更多细节？

- 在 [github](https://github.com/catppuccin/nvim) 上访问 catppuccin！