**We won't support self-compiled `neovim`**.

## SSH key configuration for GitHub (Optional)

This step is only required if you want to use SSH to clone and update plugins.

1. Add a ssh key to your GitHub account: [adding-a-new-ssh-key-to-your-github-account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
2. Configure your SSH key, and add the following content to `~/.ssh/config`
```
Host github.com
    Hostname github.com
    User git
    IdentityFile ~/.ssh/id_rsa
```

## Required packages installation for ArchLinux

```shell
# lazygit required by tui git operations
# ripgrep required by telescope word search engine
# zoxide required by telescope-zoxide
# fd required by telescope file search engine
# yarn required by markdown preview
# ttf-jetbrains-mono-nerd required by devicons and neovide font
# lldb for lldb-vscode required by debug c/cpp/rust program
# nvm for node version manager
# make required by fzf
# unzip required by mason
# neovim version >= 0.7
# python-pynvim for neovim python module
paru -S git lazygit zoxide ripgrep fd yarn ttf-jetbrains-mono-nerd lldb nvm make unzip neovim python-pynvim

# nodejs required by copilot.lua
# node version must > 16.x (18 for example)
nvm install 18
nvm use 18

# cargo/rustc required by sniprun and rustfmt
paru -S rustup
rustup toolchain install nightly # or stable
```

## Required packages installation for Ubuntu 22.04
```shell
sudo apt install git unzip make cmake gcc g++ clang zoxide ripgrep fd-find yarn lldb python3-pip  python3-venv
# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
# nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
nvm install 18
nvm use 18
# cargo/rustc required by sniprun and rustfmt
curl https://sh.rustup.rs -sSf | sh
```

Other GNU/Linux distros also need the packages listed above, please ensure you installed all of them before you use this config.

It's so appreciated that you can edit this wiki and add your distro's installation guide!

## Required packages installation for MacOS (tested on Apple M2)
```shell
brew install git lazygit zoxide ripgrep fd yarn nvm make unzip neovim
# Noted that installing sqlite may require to manually modify the .zshrc file (follow the instruction shown with brew when installing)
nvm install 18
nvm use 18
rustup toolchain install stable # nightly is not yet tested

# install the required fonts
p10k configure # this can only be used with iterm2
# If you are not using iterm2, you can simply download the fonts in this website
# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
# in section, Manual font installation
```
### Optional packages
Some languages require _parser generator_ support from the `tree-sitter` executable _(that is, `:TSInstallFromGrammar`)_. You should install the executable using your preferred package manager.

Depending on the platform, the package name can be `tree-sitter` or `tree-sitter-cli`. If installing one of them has no effect, the other should be used. For example:
```shell
brew install tree-sitter
yarn global add tree-sitter-cli
cargo install tree-sitter-cli
```

## Recommended Terminals
[wezterm](https://wezfurlong.org/wezterm/), [kitty](https://sw.kovidgoyal.net/kitty/)

```shell
sudo pacman -S wezterm kitty
```

You need to set `nerd font`(such as `JetBrainsMono Nerd Font`) as your terminal font to show icons. 

## Recommended GUI apps
[neovide](https://github.com/neovide/neovide), [goneovim](https://github.com/akiyosi/goneovim), [nvui](https://github.com/rohit-px2/nvui)

```shell
paru -S neovide goneovim-git nvui
```
## Tools for plugins

- For [mason](https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md), you need to install corresponding language server use it.

+ `:MasonInstall rust-analyzer` for `rust`
+ `:MasonInstall json-lsp` for `json`

The default html server has bug which does not support embeded javascript completion. 

So you need to install [vscode-html-languageserver-bin](https://github.com/vscode-langservers/vscode-html-languageserver-bin) manually which will be started when you open `html` file.

```
npm i -g vscode-html-languageserver-bin
```

- For [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter#supported-languages), ensure installed parsers are configured at `lua/modules/editor/config.lua/config.nvim_treesitter()`, you can add or remove parsers on your own demand.

All of format/lint tools is configured [here](https://github.com/ayamir/nvimdots/blob/main/lua/modules/configs/completion/lsp.lua#L127).
You can use `:MasonInstall` to install them easily.

+ `:MasonInstall vint` for `vimscript`
+ `:MasonInstall stylua` for `lua`
+ `:MasonInstall clang-format` for `c/cpp`
+ `:MasonInstall black` for `python`
+ `:MasonInstall eslint` for `ts/js`
+ `:MasonInstall prettier` for `vue/ts/js/html/yaml/css/scss/markdown`
+ `:MasonInstall shfmt` for `shell`
+ `:MasonInstall shellcheck` for `shell`

You can use `FormatToggle` command to enable/disable format-on-save which is enabled by default.

Also, you can disable format-on-save for specific workspace by add its path in `lua/core/settings.lua`.

You can use `:checkhealth` command to check whether all modules works or not.

The python module is always needed, so make sure you have installed it if you `nvim` in virtual env like `venv`, `conda` etc.

You can configure these tools in your own habit like `.eslintrc.js` and `.prettierrc.json`.

Last but not least, we wrote `dots.tutor` for new users to be familar with this config ASAP, just `:Tutor dots` and enjoy it!
