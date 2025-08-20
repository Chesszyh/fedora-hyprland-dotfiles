> [!TIP]
> This page is not frequently updated, so if you can't find anything useful here, please also check the open and closed issues.

## What is the procedure for uninstalling all plugins?

`rm -rf ~/.local/share/nvim/site/lazy/*`

> [!CAUTION]
> The aforementioned command is exclusively for Unix-like systems. If you are using a different operating system, the most reliable method to determine the path of installed plugins is by typing
> ```vim
> :echo stdpath("data")."/site/lazy/*"
> ```
> in Neovim.

## Telescope colorscheme preview is not working

Check out [this comment](https://github.com/ayamir/nvimdots/pull/1085#issuecomment-1833612011).

## `nvim-qt` command not showing up

`lazy.nvim` will reset the `rtp` for better performance. In this case, `nvim-qt`'s rtp got reset, so it's not shown in the command candidate.
Add `vim.api.nvim_command("set runtimepath+=" .. global.home .. "/path/to/nvim-qt/runtime")` after `require("core.pack")` in `core/init.lua` to add `nvim-qt`'s `rtp` back.

## Clipboard for WSL2 users

Please refer to [the FAQ](https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl) and ensure that `win32yank.exe` is added to your `$PATH`. We avoid using `clip.exe` for copying because it does not handle UTF-8 strings correctly. For more details, please see [this issue](https://github.com/ayamir/nvimdots/issues/762).

## LSP servers do not start automatically

Please review [this file](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) to ensure that your directory can be detected as a valid working directory. For example (`gopls`):

> Your root directory need a `go.mod` and your `.go` file need to be created
> first. Then LSP will autostart when you edit `.go` file next time.

## How to setup [GitHub Copilot](https://github.com/features/copilot)

First ensure that your GitHub account is registered for Copilot. Then use the `:Copilot auth` command to complete the setup.

> [!WARNING]  
> If your GitHub account does not have an active Copilot subscription, you may encounter unexpected issues if, for some reason, you have completed the authentication process.

## How do I add my custom snippets?

> [!TIP]
> The base configuration includes a verbatim copy of `package.json` from `friendly-snippets` in the `snips` directory. For more advanced usage, please refer to [LuaSnip's documentation](https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md).

To add your own snippets, follow these steps (assuming you want to add snippets for `golang`):

1. Verify the location of the snippet file for your language as defined in `package.json`.

![Example of `go.json` placement](https://raw.githubusercontent.com/ayamir/blog-imgs/main/20211223170133.png)

2. Create a `snippets/go.json` file and populate it with content similar to this:

```bash
touch snippets/go.json
```

![Example content of `go.json`](https://raw.githubusercontent.com/ayamir/blog-imgs/main/20211223170354.png)

3. Finally, confirm that your new snippets are working as expected.

![Result example](https://raw.githubusercontent.com/ayamir/blog-imgs/main/20211223170622.png)

## LSP server startup failed

To ensure that the LSPs installed from `npm` operate correctly, it's crucial to use the latest LTS version (e.g., `v16.13.2`).

Detailed debugging information can be found in `~/.cache/nvim/lsp.log`.

To review the most recent error details, you can use `tail ~/.cache/nvim/lsp.log`.

## Breakpoint not reached when debugging C/C++ projects

Ensure that you compile your program with the `-g` flag (or equivalent) enabled to include debugging information.

## Change dashboard startup image

Set `dashboard_image` in `lua/user/settings.lua`, i.e.:

```lua
settings["dashboard_image"] = {
	-- Your ascii image
}
```

## How to remove `nvimdots`

- \*nix:

```sh
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
```

- Windows:

Remove these two folders: `~\AppData\Local\nvim` and `~\AppData\Local\nvim-data`.

> [!TIP]
> To **completely** uninstall Neovim and delete all associated data, refer to `:h stdpath()` and remove all paths listed there.

## Issues while using [clangd](https://clangd.llvm.org/)

Ensure that **at least one** of the following tools is available on your `$PATH` (depending on the language you are using with the server):
- `clang++`
- `clang`
- `gcc`
- `g++`

### macOS

For macOS users, you can often achieve this by installing LLVM, which includes the entire suite:

```shell
brew install llvm
```

If you are using `nix-darwin`, then add `pkgs.llvm` to `environment.systemPackages`:

<details>

<summary>Example <code>darwin-configuration.nix</code></summary>

<br>

```nix
{ config, pkgs, lib, ... }:

let
  inherit (pkgs) callPackage fetchFromGitHub;
  inherit (builtins) fetchTarball;

  homeDir = builtins.getEnv "HOME";

in
{
  # auto gc
  nix = {
    gc = {
      automatic = true;
      options = "--max-freed $((25 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | awk '{ print $4 }')))";
    };
    package = pkgs.nixUnstable;

    # enable flake and experimental command
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      trusted-users = root ${username}
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  environment = {
    systemPackages = with pkgs; [
    llvmPackages
    ];

    # add shell installed by nix to /etc/shells
    shells = with pkgs; [
      zsh
    ];

    # Setup environment variables to pass to zshrc
    variables = {
      PATH = "${pkgs.llvmPackages.out}/bin:$PATH";
    };
  };

  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;
  };

}
```

</details>