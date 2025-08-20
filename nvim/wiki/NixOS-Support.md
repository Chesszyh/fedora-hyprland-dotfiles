# NixOS Support (via home-manager)

This repository contains the `homeManagerModule` for [home-manager](https://github.com/nix-community/home-manager) using [flakes](https://nixos.wiki/wiki/Flakes).
No matter which OS you are using, you can use this configuration out of the box, as long as you use home-manager to manage your environment.

## Prerequisites

Add the `home-manager` URL and `nvimdots` to `inputs` in the top-level `flake.nix`.
Next, add the following snippets to your `configuration.nix` and `nvimdots.nix`.
Re-login to your shell after executing `nixos-rebuild switch --flake <flake-url>` or `home-manager switch --flake <flake-url>`.

- `flake.nix`

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvimdots.url = "github:ayamir/nvimdots";
    home-manager = {
      url = "github:nix-community/home-manager";
      nixpkgs.follows = "nixpkgs";
    };
    # ...
  };
  # ...
}
```

- `configuration.nix`
  - This is only required if you're using NixOS. [See the FAQ section for details on this.](#masonnvim-cannot-build-some-of-the-packages-or-execute-those-installed-binaries)

```nix
{
  # Other contents...
  programs.nix-ld.enable = true;
  # ...
}
```

- `nvimdots.nix`
  - `setBuildEnv`: If set, automatically configures your `$CPATH`, `$CPLUG_INCLUDE_PATH`, `$LD_LIBLARY_PATH`, `$LIBRARY_PATH`, `$NIX_LD_LIBRARY_PATH`, and `$PKG_CONFIG_PATH`.
  - `withBuildTools`: If set, automatically installs some build utils such as `gcc` and `pkg-config`.
  - **Caveats:**
    - `setBuildEnv` and `withBuildTools` is only required on NixOS. [Q&A for this details](#mason.nvim-cannot-build-some-of-the-packages-or-execute-those-installed-binaries)
    - These are required tooling so that `mason.nvim` and `nvim-treesitter` can work as expected.
    - They bundle with `neovim` and won't affect other sessions.

```nix
{
  programs.neovim.nvimdots = {
    enable = true;
    setBuildEnv = true;  # Only needed for NixOS
    withBuildTools = true; # Only needed for NixOS
  };
}
```

## `dotnet` installation and environment variables

This repository provides `programs.dotnet.dev` to manage `dotnet` installation and environment variables inspired by `programs.java` in `home-manager`.
See [dotnet/default.nix](https://github.com/ayamir/nvimdots/blob/main/nixos/dotnet/default.nix) for a list of available options.

```nix
programs.dotnet.dev = {
  enabled = true;
  environmentVariables = {
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "0";  # Will set environment variables for DotNET.
  };
}
```

## Strict plugin management

By default, `lazy-lock.json` is not shared between machines.
This is because placing it under `nix`'s control would make it a read-only file, making it difficult to update at will.
This goes against the `nix` ethos in terms of reproducibility, but it is a trade-off for convenience.

If you want more strict management that ensures reproducibility, you can set `programs.neovim.nvimdots.bindLazyLock=true` and place the file under `nix` management.  
Running `:Lazy restore` restores the plugin versions.
You will get an error that it is a read-only file, but this can be ignored.
The following sample workflow updates the plugin version regularly.

<details><summary>sample github workflow</summary>

```yaml
name: auto merge upstream
on:
  workflow_dispatch: # allows manual triggering
  schedule:
    - cron: "0 17 * * 5"

permissions:
  contents: write
  pull-requests: write
jobs:
  auto-merge-upstream:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: andstor/file-existence-action@v3
        id: check_lockfile
        with:
          files: "lazy-lock.json"

      - name: Merge upstream
        id: merge-upstream
        continue-on-error: true
        run: |
          git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git config --global user.name "github-actions[bot]"

          git remote add upstream https://github.com/ayamir/nvimdots.git
          git fetch upstream
          git merge upstream/main --allow-unrelated-histories --no-commit --no-ff

          git reset HEAD lazy-lock.json

          git checkout lazy-lock.json

      - uses: rhysd/action-setup-vim@v1
        if: steps.check_lockfile.outputs.files_exists == 'true'
        with:
          neovim: true

      - name: Run lockfile-autoupdate
        if: steps.check_lockfile.outputs.files_exists == 'true'
        timeout-minutes: 5
        run: |
          ./scripts/install.sh
          nvim --headless "+Lazy! update" +qa
          cp -pv "${HOME}/.config/nvim/lazy-lock.json" .
          git add lazy-lock.json

      - uses: stefanzweifel/git-auto-commit-action@v5
        if: steps.check_lockfile.outputs.files_exists == 'true' || steps.merge-upstream.outcome == 'success'
        with:
          commit_message: "chore: auto merge upstream and update lazy-lock.json"
          commit_user_name: "github-actions[bot]"
          commit_user_email: "41898282+github-actions[bot]@users.noreply.github.com"
          commit_author: "github-actions[bot] <41898282+github-actions[bot]@users.noreply.github.com>"
```

</details>

## Balancing flexibility

You can set `programs.neovim.nvimdots.mergeLazyLock=true`, if you want to allow changes using `lazy.nvim` while still managing versions.
This option has the following logic:

1. `lazy-lock.json` in the repository is managed as `lazy-lock.fixed.json` in `/nix/store`.
2. Not existing `lazy-lock.json` under `${XDG_CONFIG_DIR}/nvim`, copy to then. (probably for first time.)
3. Existing `lazy-lock.json` under then, one of the following will be executed.
  1. When the hash of `lazy-lock.fixed.json` changes (i.e. when the upstream `lazy-lock.json` is changed),   
  Creating new `lazy-lock.json` by merged `lazy-lock.fixed.json` to existing `lazy-lock.json` (not managed by `nix`) under then.  
  In this case, the version in `lazy-lock.fixed.json` takes precedence.
  This means that plugins that are already managed upstream will have the lazy-lock.fixed.json version prioritized, and new plugins added that haven't yet been pushed upstream will be preserved.
  2. When the hash of `lazy-lock.fixed.json` no changes (i.e. when the upstream `lazy-lock.json` is not changed),
  `lazy-lock.json` under `${XDG_CONFIG_DIR}/nvim` is unchanged.  
  This means that your local changes will be preserved until `lazy-lock.json` is changed upstream.
  
If you want to pin the package version in `lazy-lock.json` permanent, push your local `lazy-lock.json` to the your repository.

If you have made local changes but would like to revert to the upstream version, follow these steps:
1. unlink `${XDG_CONFIG_DIR}/nvim/lazy-lock.fixed.json`
2. Run `systemctl restart home-manager-<user>.service` (NixOS) or  
 `home-manager generations | head -n1 | awk -F '-> ' '{print $2 "/activate"}'` (standalone home-manager).

## Customize your experience (Available Options)

Have a look at [default.nix (selection)](https://github.com/ayamir/nvimdots/blob/main/nixos/neovim/default.nix) for more information.

## FAQ (Frequently Asked Questions)

### `mason.nvim` cannot build some of the packages or execute those installed binaries

This is because some dependencies are not distributed along with the system - NixOS does not conform to the [Filesystem Hierarchy Standard (FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard), so some ingenuity is required.

This `homeManagerModule` provides several options to simplify dependency resolution. Nevertheless, you may still use `programs.neovim.extraPackages`, `programs.neovim.extraPython3Packages`, `programs.neovim.extraLuaPackages` provided by home-manager.

- `nvimdots.nix`

```nix
{pkgs, ...}:
{
  programs.neovim.nvimdots = {
    enable = true;
    setBuildEnv = true;
    withBuildTools = true;
    withHaskell = true; # If you want to use Haskell.
    extraHaskellPackages = hsPkgs: []; # Configure packages for Haskell (nixpkgs.haskellPackages).
    extraDependentPackages = with pkgs; [] # Properly setup the directory hierarchy (`lib`, `include`, and `pkgconfig`).
  }
}
```

### How to add dependencies?

You should include the necessary packages for building this dependency, including `include`, `lib`, and `pkgconfig` requirements, in `programs.neovim.extraDependentPackages`.

- As an example, for runtime dependencies, add the corresponding dependencies to `home.packages` or `programs.neovim.extraPackages`.
- NOTE: `home.packages` is effective inside the user scope whereas `programs.neovim.extraPackages` is effective inside the entire neovim scope. Some languages may also require the use of wrapper, see below example for details.

```nix
{ pkgs, ... }:
{
  # Install to the user scope.
  home.packages = with pkgs; [
    go
  ];
  programs.neovim = {
    # Packages only accessible from neovim
    nvimdots = {
      # Packages that require `include`, `lib`, `pkgconfig`
      extraDependentPackages = with pkgs; [ icu ];
      # Haskell packages can be easily installed with the `nvimdots` options.
      extraHaskellPackages = hs: with hs; [ ghcup ];
    };
    extraPackages = with pkgs; [
      go

      # Some languages require the use of wrapper.
      rWrapper.override
      {
        packages = with pkgs.rPackages;
          [ xml2 lintr roxygen2 ];
      }
    ];
    # Python and Lua packages can be easily installed with the corresponding `home-manager` options.
    extraPython3Packages = ps: with ps; [
      numpy
    ];
  };
}

```

### How to check if a binary can run on NixOS

Contains a verification script.  
Running script with `nix run github:ayamir/nvimdots#check-linker` that can be used to check `${XDG_DATA_DIR}/nvim/mason/bin` directory (the default on Linux is `XDG_DATA_DIR=~/.local/share`) for missing symlinks.
If `NVIM_APPNAME` environment variable is set, the script will check `${XDG_DATA_DIR}/${NVIM_APPNAME}/mason/bin` directory instead.

### How to check settings and plugin changes in advance

Contains a minimal shell environment trying `ayamir/nvimdots`.Build the environment with `nix develop github:ayamir/nvimdots`.  
Since `NVIM_APPNAME=nvimdots` is set, it will not conflict with the existing neovim environment.
Plugins download to `${XDG_DATA_DIR}/nvimdots`.  
If you want to try your own settings, after cloning the repository, edit `lua/user` and [nixos/testEnv.nix](https://github.com/ayamir/nvimdots/blob/main/nixos/dotnet/default.nix) and run `nix develop .#default`.

### Required packages for building `mason.nvim`'s dependent sources (as of 2023/08/19)

This list is incomplete - not all `mason.nvim`'s dependent sources are tracked and included. You can help by adding missing items.

| Language | extraPackages                                                                    | extraDependentPackages |
| -------- | -------------------------------------------------------------------------------- | ---------------------- |
| Go       | -                                                                                | `hunspell`             |
| PHP      | `php phpPackages.composer`                                                       | -                      |
| R        | `rWrapper.override { packages = with pkgs.rPackages; [ xml2 lintr roxygen2 ]; }` | -                      |
| Vala     | `meson` `vala`                                                                   | `vala` `jsonrpc-glib`  |

### How to check for the list of required dependencies (for `mason.nvim`'s packages)

- For binaries, `patchelf --print-needed <binary>` will list the required packages.
- You can also check the information used by `ldd` in this package and/or dynamiclib with `ldd <binary>`.
- You can check the list of dependencies required during build time using the build log (via `mason.nvim`'s UI).
- If this dependency is included in `nixpkgs`, you may be able to find the package you need by looking at the `*.nix` sources.
- If you want to be on the safe side, here is a list of dependencies for all packages that have already been registered in `mason-registry`:

```console
libamd     <==> https://github.com/zship/libamd
libc       <==> https://www.gnu.org/software/libc/
  [OR] libc++ <==> https://libcxx.llvm.org/
libevent   <==> https://libevent.org/
libiconv   <==> https://www.gnu.org/software/libiconv/
libmsgpack <==> http://msgpack.org/
libz       <==> https://www.zlib.net/
libzstd    <==> https://github.com/facebook/zstd
```

### What to do if you can't build a package via `mason.nvim`

If it is provided by `nixpkgs`, you should be able to use it by adding the following settings. This is the same as setting up other packages that require external installation:

```lua
-- Setup lsps that are not supported by `mason.nvim` but supported by `nvim-lspconfig` here.
if vim.fn.executable("dart") == 1 then
	local _opts = require("completion.servers.dartls")
	local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
	nvim_lsp.dartls.setup(final_opts)
end
```

### Something is wrong with the plugin

NixOS (home-manager) creates a symbolic link to a read-only file, so `lazy.nvim` cannot write to the file and cannot manage packages.
This implementation avoids linking `lazy-lock.json` by default.  
Therefore, it is possible that a package newer than `lazy-lock.json` managed by `ayamir/nvimdots` has been installed, and that it does not work because a breaking change has been made in that package.  
Copy `lazy-lock.json` from `ayamir/nvimdots` to `XDG_CONFIG_HOME/nvim` and start `neovim` again to check if it works.
