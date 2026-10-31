{ config, pkgs, inputs, ... }:

{
imports = [
   ./modules/programs
   ./modules/flakes
   ./profile/desktop/hyprland
];


  home.username = "wardar";
  home.homeDirectory = "/home/wardar";
  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;


  home.packages = with pkgs; [
    noctalia-shell
    bat
    htop
    slurp
    wl-clipboard
    grim
    papirus-icon-theme
    firefox
    tor-browser
    onlyoffice-desktopeditors
    steam
    fastfetch
    zapzap
    alacritty
    ghostty
    zed
    vlc
    kdePackages.gwenview
    yt-dlp
    ffmpeg
    cliphist
    bibata-cursors
    krita
    imagemagick
    tree
    telegram-desktop
    vesktop
    prismlauncher
    qbittorrent 
    thunar
    obsidian
    telegram-desktop
    android-studio
    android-tools
    jetbrains.idea
    obs-studio
    kdePackages.kdenlive
    appimage-run
    electron
    nodejs
    wine
    claude-code
    kdePackages.filelight
    python3
    renpy
    cargo
  ];
}

