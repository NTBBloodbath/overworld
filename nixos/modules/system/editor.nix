{
  lib,
  pkgs,
  inputs,
  ...
}: let
  binpath = lib.makeBinPath (
    with pkgs; [
      lua-language-server
      nil # nix-ls
      stylua
      lua51Packages.lua
      lua51Packages.luarocks
    ]
  );
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    extraLuaPackages = p: [p.magick]; # I can't have rocks.nvim install it b/c that version will not find imagemagick c binary
    luaRcContent =
      /*
      lua
      */
      ''
        vim.g.nix_packdir = "${pkgs.vimUtils.packDir pkgs.neovim-stable.passthru.packpathDirs}"
        vim.cmd.source(('~/.config/%s/init.lua'):format(vim.env.NVIM_APPNAME or 'nvim'))
      '';
  };
  fullConfig = (
    neovimConfig
    // {
      wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs
        + " --prefix PATH : ${binpath}";
    }
  );
in {
  nixpkgs.overlays = [
    (_: super: {
      neovim-stable =
        pkgs.wrapNeovimUnstable (super.neovim-unwrapped.overrideAttrs (oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [super.tree-sitter];
        }))
        fullConfig;
      neovim-nightly =
        pkgs.wrapNeovimUnstable (inputs.neovim-nightly-overlay.packages.${pkgs.system}.default.overrideAttrs (oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [super.tree-sitter];
        }))
        fullConfig;
    })
  ];

  environment.systemPackages = with pkgs; [
    neovim-stable
    # neovim-nightly
  ];
}
