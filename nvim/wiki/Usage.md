Get to know this configuration: `:Tutor dots`!

## Universal settings

All commonly used entries have been implemented in [settings.lua](https://github.com/ayamir/nvimdots/blob/main/lua/core/settings.lua).

## Structure

`init.lua` is the config root. It requires configurations inside the `lua`
directory.

- `lua` directory contains 4 parts.

  - `core` directory contains base configuration for neovim.

  - `keymap` directory contains keybindings for plugins.

  - `modules` directory contains three main subfolders.

    - `plugins/{scope}.lua` contains plugins within the corresponding scope. See below for details.

    - `configs/{scope}/` directory contains plugin settings according to the given scope.

    - `utils/icons.lua` contains icons used for plugin settings. See below for details.

    - `utils/dap.lua` contains several most commonly used functions for DAP config files.

    - `utils/keymap.lua` contains auxiliary functions for key remaps. This is not designed to be used directly.

    - `utils/init.lua` contains utility functions used by plugins. See below for details.

    - **{scope} definition**
      - `completion` contains plugins for code completion.

      - `editor` contains plugins that improve the default ability of vanilla `nvim`.

      - `lang` contains plugins related to certain programming languages.

      - `tool` contains plugins using external tools and changing the default layout which provides new abilities to `nvim`.

      - `ui` contains plugins rendering the interface without any actions after the user fires `nvim`.

  - `user` directory contains user custom configs.

    - `plugins/{scope}.lua` contains user-added (custom) plugins within the corresponding scope.
    - `configs/{plugin-name}.lua` contains default plugin overrides using the plugin's base config filename.
    - `configs/` directory contains user-added plugin settings according to the scope.
      - `dap-clients/` directory contains the settings of DAP clients.
      - `lsp-servers/` directory contains the settings of LSP servers.

    - `keymap/` directory contains custom keybindings.
    - `event.lua` contains custom user events.
    - `options.lua` contains vanilla `nvim`'s option overrides.
    - `settings.lua` contains settings overrides.

- The `modules` directory's default (or base) file tree is as follows:

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

## How to customize according to your preferences

### About user overrides (settings, options, events, etc.)
> **Note:**
> - `lua/user` is [in the search path of `require`](https://github.com/ayamir/nvimdots/blob/647c23f9973fbb4a1228948afeb792e15b8c04a0/lua/core/pack.lua#L26-L34). So for example, instead of requiring `user.configs.editor` you should use `configs.editor` instead.
> - The discussions in [#888](https://github.com/ayamir/nvimdots/issues/888), [#972](https://github.com/ayamir/nvimdots/issues/972), and [#973](https://github.com/ayamir/nvimdots/pull/973) may be useful if you want to know more implementation details.

Generally speaking, we have a custom loader for user configs that honors your preferences (which means it'll either _merge with_ or _overwrite_ the base configs). It has the following characteristics:
- It always replaces a value if the corresponding key exists in the base table to be merged with.
- It always appends the (key, value) pair if the key does not exist in the table.
- If the existing table is a nested table, it behaves as follows:

  - If the user provides a table,
    - It always appends the given values (and ignores the keys) if the nested table is a list;
    - It always updates the corresponding value or appends the (key, value) pair if the nested table is a dictionary
  - If the user provides a function,
    - It completely replaces the target table, no matter it's nested or not.

For example, if the default setting for `lsp_deps` is:

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

You may tweak the configs as follows (via `user/settings.lua`):

- To merge the entries

```lua
settings["lsp_deps"] = {
	"zls", -- zig lsp
}
--[[
Would result in:
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

- To overwite the entries

```lua
settings["lsp_deps"] = function(defaults)
	return {
		defaults[5], -- "lua_ls"
		defaults[6], -- "pylsp"
		"zls", -- zig lsp
	}
end
--[[
Would result in:
  {
    "lua_ls",
    "pylsp",
    "zls"
  }
--]]
```

Note that the underlying implementation (`load_plugin()`) always provides the `defaults` table as the first argument passed to your function.
That is:

```lua
-- Tweak bufferline.lua via user/configs/bufferline.lua
return function(defaults)
	 return {
	 	 options = {
	 	 	 number = nil,
			-- Other configs...
	 	 	 color_icons = defaults.options.color_icons, -- reference to the base config
		}
	}
end
```

### Steps to override existing plugin `lazy.nvim` related configs

1. Set your config in `user/plugins/<scope>.lua`.

Example: Set `lazy = false` for `olimorris/persisted.nvim` in `user/plugins/editor.lua`.
```lua
editor["olimorris/persisted.nvim"] = {
	lazy = false,
}
```

### Steps to modify plugin configs

1. Check whether the plugin is written in `lua` or not.

2. Add a new entry in `user/configs/<plugin-name>.lua`. Note that the file must have the same name as the parent spec defined in `lua/modules/configs/<scope>/`.

3. If your plugin is written in `lua`, override it via: _(See below for an example)_

   - Returning a table if you just want to replace _some_ base configs defined in `modules/configs/<scope>/<plugin-name>.lua`.

   - Returning a function if you want to _completely_ replace the base config defined in `modules/configs/<scope>/<plugin-name>.lua`.

   - Returning `false` if you don't want to call the `setup` function (that is, you want to use the default options of the plugin).

4. If your plugin is written in `Vimscript`, override it via: _(See below for an example)_

- Returning a function containing sequences of `vim.g.<options> = foobar`.

Example: (If the plugin is written in `lua`):

- `user/configs/telescope.lua`

  - Update value or add (key, value) pair by `return`ing a table.

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

  - Full replacement of defaults by `return`ing a function

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

Example (If the plugin is written in `VimScript`):

- `user/configs/vim-go.lua`

```lua
return function()
	vim.g.go_doc_keywordprg_enabled = 1
end
```

### Steps to add a new plugin

1. Make a sub-directory called `<scope>` under `user/configs/` and a file called `<scope>.lua` under `plugins/`. `<scope>.lua` should contain the following initial content:
> **Note:** Here we adopt a structure similar to `lua/modules/configs` for user configuration

```lua
local custom = {}

return custom
```

2. Add this new plugin following the format that other plugins are configured in `plugins/` and `configs/`. Specifically:

   - Add a new entry in `user/plugins/<scope>.lua` _(See below for an example)_

   - Create a new `.lua` file with plugin name as the filename under `user/configs/<scope>` _(the filename can be slightly different, as long as it can be understood by you)_.

Example:

- `user/plugins/editor.lua`

```lua
local custom = {}

custom["folke/todo-comments.nvim"] = {
	lazy = true,
	event = "BufRead",
	config = require("configs.editor.todo-comments"), -- Require that config
}

return custom
```

- `user/configs/editor/todo-comments.lua`

```lua
return function() -- This file MUST return a function accepting no parameter and has no return value
	require("todo-comments").setup()
end
```

If you want to add a VimScript plugin with modified configuration, you should use `init` rather `config`. For example:

- `user/plugins/editor.lua`

```lua
local editor = {}
editor["mg979/vim-visual-multi"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
        -- use init rather than config
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

### Full Example
Let's apply the above steps to an actual situation:

- I want to modify the settings of `specs.nvim` (`modules/configs/ui/specs.lua`):

We have the base spec ([`specs.lua`](https://github.com/ayamir/nvimdots/blob/f8103f07c4b9260a0cb4e507666f9ff248038dca/lua/modules/configs/ui/specs.lua)) as follows:
```lua
return function()
	require("modules.utils").load_plugin("specs", {
		show_jumps = true,
		min_jump = 10,
		popup = {
			delay_ms = 0, -- delay before popup displays
			inc_ms = 10, -- time increments used for fade/resize effects
			blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
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

1. Create `user/configs/specs.lua`;

2.1. **I want to set `popup.delay_ms` to 20**:
```lua
-- Other configs... (new autocmds, usercmds, etc.)

return {
	popup = {
		delay_ms = 20,
	}
}
```
`load_plugin` will merge this spec with the parent spec, and then call `require("specs").setup({final_spec})`

2.2. **I want to customize this plugin myself**:
```lua
return function(defaults) -- This is the parent spec in case you want to have some references
	-- Other configs... (new autocmds, usercmds, etc.)

	defaults.show_jumps = true
	-- OR (complete replacement) --
	defaults = { show_jumps = true }

	-- And finally... --
	return defaults
end

-- OR You may just do --

return function()
	return { show_jumps = true }
end
```
And `load_plugin` would instead do: `require("specs").setup({opts})`

OR You can replace the configuration completely by return a function which calls `require("specs").setup({})`

```lua
return function()
    require("specs").setup({
         -- opts
    })
end
```

**Don't call `load_plugin` in your override file which will cause infinite recursive invoke then stack overflow.**

2.3 **I want to use the plugin's default options**:
```lua
return false
```

- I want to add a new plugin:

Adding a plugin is as simple as adding the plugin spec to one of the files under `user/plugins/*.lua`. You can create as many files there as you want.

You can structure your lua/plugins folder with a file per plugin, or a separate file containing all the plugin specs for some functionality. Example:
```lua
return {
	-- add symbols-outline
	["simrat39/symbols-outline.nvim"] = {
	 	 lazy = true,
	 	 cmd = "SymbolsOutline",
	 	 opts = {
			-- add your options that should be passed to the setup() function here
	 	 	 position = "right",
		},
		-- OR --
	 	config = function()
			-- setup the plugin urself
	 	 end
		-- OR --
	 	config = require("configs.symbolsoutline") -- This works as well
	},
}
```

_(If you need help, feel free to open an issue.)_

### Steps to disable a plugin

1. Add the plugin's full (repo) name to `settings["disabled_plugins"]` inside `user/settings.lua`.

> **NOTE**: You have no need to add original repo to `disabled_plugins` if you want to use a forked repo, see [#1077](https://github.com/ayamir/nvimdots/issues/1077) and [#1079](https://github.com/ayamir/nvimdots/pull/1079).

Example:

- `lua/settings.lua`

```lua
-- Disable the following two plugins
settings["disabled_plugins"] = {
	"karb94/neoscroll.nvim",
	"dstein64/nvim-scrollview",
}
```

### Modify Keymaps

- For vanilla `nvim` keymaps

  Modify `user/keymap/core.lua`

- For specific plugin's keymaps

  Modify `user/keymap/<scope>.lua`

- Command breakdown

  ```lua
      ┌─ sep     ┌── map_type
   ["n|gb"] = map_cr("BufferLinePick"):with_noremap():with_silent(),
     │  └── map_key          │              └── special     │
     └──── map_mode          └── map_content                └── special (can be chained)
  ```

- Set the value to empty or `false` to remove the base keymap.

Example

- `user/keymap/ui.lua`

```lua
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {
	-- Remove default keymap
	["n|<leader>nf"] = "",
	["n|<leader>nr"] = false,
	-- Plugin: telescope
	["n|<leader><S-cr>"] = map_callback(function()
			_command_panel()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("tool: Toggle command panel"),
}
```

### Modify LSPs, linters and formatters

- Add/remove Language Server Protocol (LSP) servers

  Modify `user/settings` -> `settings[lsp_deps]`, you can find available sources [here](https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations). Then add a server config file in `user/configs/lsp-servers`, see `lua/modules/configs/completions/servers/` for how to configure servers, you can take other server's config file as a reference. Restart `nvim` to install the new LSP servers.

  **Note**: Some LSPs are already being shipped when installing the runtime packages. Like `dartls` is being shipped when installing `dart` runtime, so users won't see those LSPs when calling `:Mason`, see [#525](https://github.com/ayamir/nvimdots/pull/525).

- Add/remove linters and formatters

  Modify `user/settings` -> `settings[null_ls_deps]`, you can find available sources [here](https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins). If you want to change the behavior of a specific `null-ls` source, set the extra arguments in `user/configs/null-ls.lua` -> `sources` table. _(See below for an example)_ Restart `nvim` to install the new `null-ls` sources.

Example

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

**Note**: Some linters and formatters are already being shipped when installing the runtime packages. For example, `dart_format` is being shipped when installing `dart` runtime, so users won't see those formatters when calling `:Mason`. Just set `dart_format`, for example, in the `settings[null_ls_deps]` table, and `mason-null-ls` will set it up for you, see [#525](https://github.com/ayamir/nvimdots/pull/525) for more.

- Change Formatter's global behavior

  - Disable formatting on certain filetype

    Modify `user/settings` -> `settings[formatter_block_list]`.

  - Disable formatting ability on certain LSP server

    Modify `user/settings` -> `settings[server_formatting_block_list]`.

  - Define extra <formatter> args

    Create a file called `<formatter_name>.lua` under `lua/user/configs/formatters/` and return a table including args.

    For example: create a file called `clang_format.lua` under `lua/user/configs/formatters/` and fill the content with `return {"-style=file"}`. (Then the `clang_format` will respect the format-related file like `.clang-format` under the project root directory.)

- Changes in LSP server and Linter behavior

  - Create and edit `user/configs/lsp-servers/<server-name>.lua`.
  - See `lua/modules/configs/completions/servers/`.

### Modify DAP Clients

- Add/remove Debug Adapter Protocol (DAP) clients
  Modify `user/settings` -> `settings[dap_deps]`, you can find available sources [here](https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua). Then add a client config file in `user/configs/dap-clients`, see `lua/modules/configs/tool/dap/clients/` for how to configure dap clients, you can take other client config files as a reference. Restart `nvim` to install the new DAP clients.

### Modify event defined by `autocmd`

- Modify `user/event.lua`

- See `lua/core/events.lua` for the avalilable keys.

Example

- `user/events.lua`

```lua
local definitions = {
	-- Example
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
	},
}

return definitions
```

### Modify vanilla `nvim` options

- Modify `user/options.lua`

- Global options are listed directly.

Example

- `user/options.lua`

```lua
vim.g.editorconfig = 0
local options = {
	autoindent = true,
}

return options
```

### Modify settings

- Modify `user/settings.lua`.

- See `lua/core/settings.lua` for the keys and corresponding valid values.

Example

- `user/settings.lua`

```lua
local settings = {}

-- Examples
settings["use_ssh"] = true

settings["colorscheme"] = "catppuccin"

return settings
```

### Switch `colorscheme`

- Modify the value of `colorscheme` in `user/settings.lua`.

```lua
-- Set colorscheme to catppuccin-latte for example
settings["colorscheme"] = "catppuccin-latte"
```

**NOTE**: The `colorscheme` of `lualine` will also be changed according to the current `colorscheme` of `nvim`. Please see the function `custom_theme` in `lua/modules/configs/ui/lualine.lua` if you are interested in it.

All of the modified configs will have effects after you restart `nvim`.

## Global assets

### Palette

This configuration provides a global unified palette. You may use `require("modules.utils").get_palette({ <color_name> = <hex_value> }?)` to get the global color palette. Specific colors may be overwritten in [settings.lua](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/core/settings.lua#L18-L23) or can be passed in as function parameter(s). You will get parameter completion when typing.

The order of priority for modifying the palette is:

```
preset colors < global colors defined in `settings.lua` < incoming function parameters
```

All available colors can be found [here](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/utils/init.lua#L3-L30). You can also explore implementation details in this file.

### Icons

This configuration also provides a dedicated icon set. It can be accessed via `require("modules.utils.icons").get(category, add_space?)`. You will get parameter completion when typing.

You can find the list of icons [here](https://github.com/ayamir/nvimdots/blob/main/lua/modules/utils/icons.lua).

## Operation manual

- Find word

[![hop to find word](https://s2.loli.net/2022/01/06/WZKjvaF8qGEYP5R.png)](https://youtu.be/Otz09Gdk4NA)

- Region operation

[![region operation](https://s2.loli.net/2022/01/06/PzcmOIksQNbeEpA.png)](https://youtu.be/4esdUMHXNTo)

## Guide on how to use the catppuccin colorscheme

### What is Catppuccin? <sup><a href="https://www.reddit.com/r/neovim/comments/r9619t/comment/hna3hz8">[[1]](https://www.reddit.com/r/neovim/comments/r9619t/comment/hna3hz8)</a></sup>

> Catppuccin is a community-driven soothing pastel theme that aims to be the middle ground between low and high-contrast themes, providing a warm color palette with 26 eye-candy colors that are bright enough to be visible during the day, yet pale enough to be easy on your eyes throughout the night.

### Basic Usage

Modify [these lines](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/catppuccin.lua#L2-L89). _(Note: This link might be slightly different from `HEAD`, but it can be used as a reference.)_ See detailed explanation of each option below.

#### General

These settings are unrelated to any group and are globally independent.

- `flavour`: _(Can be any one of: `latte`, `frappe`, `macchiato`, or `mocha`)_ This is **mandatory**. You **must** set this value in order to make catppuccin work correctly. Note that `latte` is a light colorscheme, and the rest are dark schemes; The `mocha` palette is the only one that has been modified to make catppuccin look like the v0.1 one. Check out [this PR](https://github.com/ayamir/nvimdots/pull/163) for details.
- `transparent_background`: _(Boolean)_ if true, disables setting the background color.
- `term_colors`: _(Boolean)_ if true, sets terminal colors (a.k.a., `g:terminal_color_0`).

#### Dim inactive

This setting manages the ability to dim **inactive** splits/windows/buffers.

- `enabled`: _(Boolean)_ if true, dims the background color of inactive window or buffer or split.
- `shade`: _(string)_ sets the shade to apply to the inactive split or window or buffer.
- `percentage`: _(number from 0 to 1)_ percentage of the shade to apply to the inactive window, split or buffer.

#### Styles

Handles the style of general highlight groups _(see `:h highlight-args` for detailed explanation)_:

- `comments`: _(Table)_ changes the style of comments.
- `functions`: _(Table)_ changes the style of functions _(e.g., [button](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/alpha.lua#L28) in config)_.
- `keywords`: _(Table)_ changes the style of keywords _(e.g., `local`)_.
- `strings`: _(Table)_ changes the style of strings.
- `variables`: _(Table)_ changes the style of variables.
- `properties`: _(Table)_ changes the style of a phantom field with only getter and/or setter _(e.g., field access `tbl.field`)_.
- `operators`: _(Table)_ changes the style of operators.
- `conditionals`: _(Table)_ changes the style of conditional check keywords _(e.g., `if`)_.
- `loops`: _(Table)_ changes the style of loop keywords _(e.g., `for`)_.
- `booleans`: _(Table)_ changes the style of booleans.
- `numbers`: _(Table)_ changes the style of numbers.
- `types`: _(Table)_ changes the style of types _(e.g., `int`)_.

#### Integrations

These integrations allow catppuccin to set the theme of various plugins. To enable an integration you need to set it to `true`.

#### Using the auto-compile feature

> Catppuccin is a highly customizable and configurable colorscheme. This does however come at the cost of complexity and execution time.

Catppuccin can pre-compute the results of configuration and store the results in a compiled lua file. These pre-cached values are later used to set highlights. The cached file is stored at `vim.fn.stdpath("cache") .. "/catppuccin"` by default _(use `:lua print(vim.fn.stdpath("cache") .. "/catppuccin")` to see where it locates on your computer)_. You may change this behavior by modifying [this line](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/catppuccin.lua#L17).

> **Note**: As of 7/10/2022, catppuccin should be able to automatically recompile when the setup table changes. You cannot disable this feature.

### Advanced Feature

#### Customizing the palette

Not satisfied with the current appearance? You may modify the palette yourself, like `mocha`!

#### Get catppuccin colors

```lua
local latte = require("catppuccin.palettes").get_palette "latte"
local frappe = require("catppuccin.palettes").get_palette "frappe"
local macchiato = require("catppuccin.palettes").get_palette "frappe"
local mocha = require("catppuccin.palettes").get_palette "mocha"

local colors = require("catppuccin.palettes").get_palette() -- current flavour's palette
```

These lines would all return a table respectively, where the key is the name of the color and the value is its hex value.

#### Overwriting highlight groups

Global highlight groups can be overwritten like so:

```lua
custom_highlights = function(cp)
	return {
		<hl_group> = { <fields> }
	}
end
```

Here is an example:

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

Per flavour highlight groups can be overwritten starting from [this line](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/catppuccin.lua#L121) like so:

```lua
highlight_overrides = {
	all = function(cp) -- Global highlight, will be replaced with custom_highlights if exists
		return {
			<hl_group> = { <fields> }
		}
	end, -- Same for each flavour
	latte = function(latte) end,
	frappe = function(frappe) end,
	macchiato = function(macchiato) end,
	mocha = function(mocha) end,
}
```

Here is an example:

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

Additionally, if you want to load other custom highlights later, you may use this function:

```lua
require("catppuccin.lib.highlighter").syntax()
```

For example:

```lua
local colors = require("catppuccin.palettes").get_palette() -- fetch colors from palette
require("catppuccin.lib.highlighter").syntax({
	Comment = { fg = colors.surface0 }
})
```

> **Note**: Custom highlights loaded using the `require("catppuccin.lib.highlighter").syntax()` function **won't** be pre-compiled.
>
> Unlike the `:highlight` command which can update a highlight group, this function completely replaces the definition. (`:h nvim_set_hl`)

#### Overwriting colors

Colors can be overwritten using `color_overrides` starting from [this line](https://github.com/ayamir/nvimdots/blob/6d814aad5455aa8d248ed6af7b56fc4e99e40f48/lua/modules/configs/ui/catppuccin.lua#L90), like so:

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

#### Want to know more details?

- Visit catppuccin on [github](https://github.com/catppuccin/nvim)!