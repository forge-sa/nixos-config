{ config, pkgs, ... }:
{
  programs.zsh = {
    autosuggestion.enable = true;
    enable = true;
    enableCompletion = true;
    history = {
      ignoreDups = true;
      path = "$HOME/.zsh_history";
      save = 10000;
      share = true;
      size = 10000;
    };
    envExtra = ''
      export DISABLE_MAGIC_FUNCTIONS=true
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
        "command-not-found"
        "z"
      ];
      theme = "agnoster";
    };
    shellAliases = {
      cim = "sudo vim";
      svim = "sudo nvim";
      ytm-dlp = ''yt-dlp -x --audio-format opus --audio-quality 0 --embed-metadata --embed-thumbnail --parse-metadata "playlist_index:%(track_number)s" -o "%(playlist_index)s - %(title)s.%(ext)s"'';
    };
    syntaxHighlighting.enable = true;
  };
}
