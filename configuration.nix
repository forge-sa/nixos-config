# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.horizon.nixosModules.default
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev"; # Use "nodev" for UEFI systems
    efiSupport = true; # Enable EFI support
    };
    efi.canTouchEfiVariables = true; # Allow touching EFI variables
  };


  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub.useOSProber = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
     intel-media-driver
     vulkan-loader
     vulkan-validation-layers
     vulkan-tools          # adds vulkaninfo, vkcube for testing
     intel-compute-runtime
     intel-vaapi-driver
    ];

    extraPackages32 = with pkgs; [
     intel-media-driver
     vulkan-loader
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.bluetooth.enable = true;


  networking.hostName = "xpert"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Almaty";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.displayManager.ly.enable = true;
  programs.hyprland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.power-profiles-daemon.enable = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.horizon.enable = true;
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
  programs.steam.protontricks.enable = true;
  services.tailscale.enable = true;
  systemd.services.battery-charge-limit = {
    description = "Set battery charge limit";
    wantedBy = [ "multi-user.target" ];
    after = [ "power-profiles-daemon.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      limit="/sys/class/power_supply/BAT0/charge_control_end_threshold"

      if [ -w "$limit" ]; then
        echo 80 > "$limit"
      else
        echo "Battery charge-limit interface not available: $limit" >&2
        exit 1
      fi
    '';
  };

  users.users."wardar" = {
    isNormalUser = true;
    description = "wardar";
    extraGroups = [ "networkmanager" "wheel" "audio" "input" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };
  security.sudo.extraRules = [
    {
      users = [ "sardar" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/vim /etc/nixos/configuration.nix";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/vim /etc/nixos/home.nix";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/vim /etc/nixos/flake.nix";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nixos-rebuild switch";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  users.users.wardar.openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFC2JBoDVXjB4h/QQddvR0yIcL9zzOrGt+SQXZslZsX3 root@server"
  ];

  nix.settings.trusted-users = [ "root" "wardar" ];
  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
      pkgs.vim     
      pkgs.neovim
      pkgs.vimPlugins.LazyVim
      pkgs.brightnessctl
      pkgs.pavucontrol
      pkgs.blueman
      pkgs.unzip
      pkgs.zip
      pkgs.oniux
      pkgs.nwg-displays
      pkgs.nh
      pkgs.glfw3-minecraft
      pkgs.javaPackages.compiler.temurin-bin.jdk-21
      pkgs.javaPackages.compiler.temurin-bin.jdk-25
      pkgs.vscodium
      pkgs.arp-scan
      pkgs.nmap
      pkgs.hydra
      pkgs.thc-hydra
      pkgs.usbutils
      inputs.ayugram-desktop.packages.${pkgs.system}.default
      inputs.helium.packages.${pkgs.system}.default
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
