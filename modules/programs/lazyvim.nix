{ lib, pkgs, ... }:

let
  # Plugins LazyVim loads by default, served from the nix store instead of git.
  # Anything not listed (e.g. plugins pulled in by extras) is downloaded as usual.
  plugins = with pkgs.vimPlugins; [
    LazyVim
    lazy-nvim
    blink-cmp
    bufferline-nvim
    conform-nvim
    flash-nvim
    friendly-snippets
    gitsigns-nvim
    grug-far-nvim
    lazydev-nvim
    lualine-nvim
    mini-ai
    mini-icons
    mini-pairs
    noice-nvim
    nui-nvim
    nvim-lint
    nvim-lspconfig
    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-ts-autotag
    persistence-nvim
    plenary-nvim
    snacks-nvim
    todo-comments-nvim
    tokyonight-nvim
    trouble-nvim
    ts-comments-nvim
    which-key-nvim
    { name = "catppuccin"; path = catppuccin-nvim; }
  ];
  mkEntryFromDrv = drv:
    if lib.isDerivation drv then
      { name = lib.getName drv; path = drv; }
    else
      drv;
  lazyPath = pkgs.linkFarm "lazy-plugins" (map mkEntryFromDrv plugins);

  # nvim-treesitter (main branch) only treats parsers inside its install_dir as installed,
  # so point it at a store dir with every grammar and all queries
  # (the full queries dir also covers inherited ones like ecma/jsx/html_tags).
  treesitterDir = pkgs.linkFarm "nvim-treesitter-grammars" {
    parser = "${pkgs.symlinkJoin {
      name = "nvim-treesitter-parsers";
      paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    }}/parser";
    queries = "${pkgs.vimPlugins.nvim-treesitter}/runtime/queries";
  };
in
{
  programs.neovim = {
    enable = true;

    # mason is disabled, so language servers and tools come from here
    extraPackages = with pkgs; [
      # LazyVim core
      lua-language-server
      stylua
      ripgrep
      fd
      lazygit
      # lang.nix extra
      nil
      nixfmt
      statix
    ];

    plugins = [ pkgs.vimPlugins.lazy-nvim ];

    initLua = ''
      require("lazy").setup({
        defaults = {
          lazy = false,
          version = false,
        },
        dev = {
          -- reuse files from pkgs.vimPlugins.*
          path = "${lazyPath}",
          patterns = { "" },
          -- fallback to download
          fallback = true,
        },
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "lazyvim.plugins.extras.lang.nix" },
          -- mason binaries don't run on NixOS, use programs.neovim.extraPackages instead
          { "mason-org/mason.nvim", enabled = false },
          { "mason-org/mason-lspconfig.nvim", enabled = false },
          -- import/override with your plugins
          { import = "plugins" },
          -- parsers come from the nix store; keep this last so nothing tries to install more
          {
            "nvim-treesitter/nvim-treesitter",
            opts = function(_, opts)
              opts.install_dir = "${treesitterDir}"
              opts.ensure_installed = {}
            end,
          },
        },
        install = { colorscheme = { "tokyonight", "habamax" } },
        -- plugins are updated through nix flake update
        checker = { enabled = false },
        performance = {
          rtp = {
            disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
          },
        },
      })
    '';
  };

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lazyvim/lua;

  # LazyVim icons are Nerd Font glyphs; fontconfig falls back to this font for them,
  # so terminals keep their own font (alacritty has no built-in Nerd Font symbols)
  home.packages = [ pkgs.nerd-fonts.symbols-only ];
  fonts.fontconfig.enable = true;
}
