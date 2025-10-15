{
  lib,
  pkgs,
  inputs,
  ...
}: let
  binpath = lib.makeBinPath (
    with pkgs; [
      gcc # Required to compile norg tree-sitter parsers
      lua-language-server
      nil # nix-ls
      stylua
      lua51Packages.lua
      lua51Packages.luarocks
    ]
  );
  # parsers = pkgs.tree-sitter.withPlugins (p: [
  #   p.tree-sitter-norg
  #   p.tree-sitter-norg-meta
  # ]);
  # vim.opt.runtimepath:append("${parsers}")
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    extraLuaPackages = p: [p.magick]; # I can't have rocks.nvim install it b/c that version will not find imagemagick c binary
    customLuaRC =
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
      wrapperArgs =
        lib.escapeShellArgs neovimConfig.wrapperArgs
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
