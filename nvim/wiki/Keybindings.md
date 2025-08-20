The default **\<leader\>** key is `<Space>`.

- Modes:
  - `N` --> Normal mode
  - `I` --> Insert mode
  - `V` --> Visual mode

- `<C-p>` indicates pressing `<Ctrl>` and `p` simultaneously.
- `<A-d>` indicates pressing `<Alt>` and `d` simultaneously.
- `<leader>ps` means pressing `<leader>`, followed by `p`, then `s`.

For macOS users, refer to [this issue](https://github.com/ayamir/nvimdots/issues/344#issuecomment-1333725188) to enable the `Alt` key functionality.

For detailed keybindings and their explanations, check out the following files:
- [lua/keymap/init.lua](https://github.com/ayamir/nvimdots/blob/main/lua/keymap/init.lua)
- [lua/keymap/completion.lua](https://github.com/ayamir/nvimdots/blob/main/lua/keymap/completion.lua)
  - [lua/modules/configs/completion/cmp.lua](https://github.com/ayamir/nvimdots/blob/main/lua/modules/configs/completion/cmp.lua) for completion-related keymaps
- [lua/keymap/editor.lua](https://github.com/ayamir/nvimdots/blob/main/lua/keymap/editor.lua)
- [lua/keymap/lang.lua](https://github.com/ayamir/nvimdots/blob/main/lua/keymap/lang.lua)
- [lua/keymap/tool.lua](https://github.com/ayamir/nvimdots/blob/main/lua/keymap/tool.lua)
- [lua/keymap/ui.lua](https://github.com/ayamir/nvimdots/blob/main/lua/keymap/ui.lua)

You can also access this information within the editor:
- Press `<C-p>` in normal mode.
- Use `:WhichKey` in command mode.
- Start typing the prefix of the keymap of interest.