# ghostty.nix
{ pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    # Explicit integration survives shell switching (e.g. bash -> zsh inside a tab).
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    themes = {
      blush = {
        background = "#FBEFF1";
        foreground = "#3A1F25";
        cursor-color = "#C8283F";
        cursor-text = "#FBEFF1";
        selection-background = "#F2C4CC";
        selection-foreground = "#3A1F25";
        palette = [
          "0=#3A1F25"  "8=#8A6B71"
          "1=#C8283F"  "9=#E0435A"
          "2=#4E8A5B"  "10=#5FA36D"
          "3=#B7791F"  "11=#D0912E"
          "4=#3E6FA8"  "12=#5584C0"
          "5=#A63D78"  "13=#C2548F"
          "6=#2F8A8A"  "14=#3FA3A3"
          "7=#D9C3C8"  "15=#FFF7F8"
        ];
      };

      blush-night = {
        background = "#1F1316";
        foreground = "#F3DDE1";
        cursor-color = "#E0435A";
        cursor-text = "#1F1316";
        selection-background = "#5A2530";
        selection-foreground = "#F3DDE1";
        palette = [
          "0=#2E1C21"  "8=#6E5157"
          "1=#E0435A"  "9=#F0677B"
          "2=#8CC79A"  "10=#A6D9B1"
          "3=#E6B566"  "11=#F0C987"
          "4=#7FA6DB"  "12=#9BBDE8"
          "5=#E07AB0"  "13=#EE9CC7"
          "6=#6CC4C4"  "14=#8ED6D6"
          "7=#E8D2D6"  "15=#FFF5F7"
        ];
      };
    };

    settings = {
      # ── Look ──────────────────────────────────────────────
      theme = "light:blush,dark:blush-night";
      split-divider-color = "#C8283F";   # crimson lines between splits, like the outline
      unfocused-split-opacity = 0.85;
      font-size = 13;
      font-feature = [ "-calt" ];          # no ligatures; `->` stays `->` in remote logs
      window-padding-x = 8;
      window-padding-y = 6;
      window-padding-balance = true;
      cursor-style = "block";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;
      resize-overlay = "never";

      # ── SSH: the important part ──────────────────────────
      # ssh-env:      sets a sane TERM + forwards COLORTERM/TERM_PROGRAM
      # ssh-terminfo: pushes xterm-ghostty terminfo to the remote host (cached)
      # sudo:         keeps terminfo working under sudo
      # title:        tab title shows user@host / cwd, so you know where you are
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title,ssh-env,ssh-terminfo";

      # ── Clipboard over SSH (OSC 52 from tmux / nvim on the remote) ──
      clipboard-read = "ask";              # remote can't silently read your clipboard
      clipboard-write = "allow";           # remote yank -> local clipboard just works
      copy-on-select = "clipboard";
      clipboard-trim-trailing-spaces = true;
      clipboard-paste-protection = true;   # warn before pasting multi-line / unsafe text
      clipboard-paste-bracketed-safe = true;

      # ── Don't lose live sessions by accident ─────────────
      confirm-close-surface = true;
      quit-after-last-window-closed = false;
      window-save-state = "always";
      scrollback-limit = 50000000;         # bytes, ~50 MB per surface
      window-inherit-working-directory = true;

      # ── Keybinds: splits/tabs for juggling several hosts ──
      keybind = [
        "ctrl+shift+enter=new_split:right"
        "ctrl+shift+backslash=new_split:down"
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:bottom"
        "ctrl+shift+k=goto_split:top"
        "ctrl+shift+l=goto_split:right"
        "ctrl+shift+z=toggle_split_zoom"
        "ctrl+shift+e=equalize_splits"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+r=reload_config"
        "ctrl+shift+f=write_scrollback_file:open"   # dump remote output to a file
        "shift+page_up=scroll_page_up"
        "shift+page_down=scroll_page_down"
      ];
    };
  };

  # ── SSH client side: makes repeat connections near-instant ──
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      controlMaster = "auto";
      controlPath = "~/.ssh/cm-%C";
      controlPersist = "10m";
      serverAliveInterval = 30;
      serverAliveCountMax = 3;
      addKeysToAgent = "yes";
      forwardAgent = false;
    };

    # Hosts the shell wrapper can't reach (IDE remotes, scripts, odd jump boxes):
    # matchBlocks."legacy-box" = {
    #   hostname = "10.0.0.5";
    #   setEnv = { TERM = "xterm-256color"; };
    # };
  };
}
