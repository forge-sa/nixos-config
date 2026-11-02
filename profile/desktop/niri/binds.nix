{ lib, ... }:

let
  fileManager = "Thunar";
  terminal = "alacritty";

  locked = cmd: {
    _props.allow-when-locked = true;
    spawn-sh = cmd;
  };

  workspaceBinds = lib.listToAttrs (
    lib.concatMap (
      workspace:
      let
        key = if workspace == 10 then "0" else toString workspace;
      in
      [
        (lib.nameValuePair "Mod+${key}" { focus-workspace = workspace; })
        (lib.nameValuePair "Mod+Shift+${key}" { move-window-to-workspace = workspace; })
      ]
    ) (lib.range 1 10)
  );
in
{
  # Mod is Super. Mod+LMB drag (move) and Mod+RMB drag (resize) are built into niri.
  wayland.windowManager.niri.settings.binds = {
    # General
    "Mod+Return".spawn-sh = terminal;
    "Mod+E".spawn-sh = fileManager;
    "Mod+X".spawn-sh = "oniux AyuGram";
    "Mod+B".spawn-sh = "firefox";
    "Mod+Q".close-window = { };
    "Mod+Shift+R".spawn-sh = "niri msg action load-config-file";
    "Mod+F".fullscreen-window = { };
    "Mod+I".maximize-column = { };
    "Mod+D".spawn-sh = "noctalia-shell ipc call launcher toggle";
    "Mod+Alt+L".spawn-sh = "noctalia-shell ipc call lockScreen lock";
    "Mod+Space".toggle-window-floating = { };
    "Mod+Tab".spawn-sh = "noctalia-shell ipc call controlCenter toggle";
    "Mod+Escape".spawn-sh = "noctalia-shell ipc call sessionMenu toggle";
    "Mod+Shift+S".spawn-sh = "/home/wardar/.local/bin/screenshot.sh";
    "Print".spawn-sh = "/home/wardar/.local/bin/screenshot.sh";

    # Window navigation
    "Mod+H".focus-column-left = { };
    "Mod+L".focus-column-right = { };
    "Mod+Up".focus-window-up = { };
    "Mod+Down".focus-window-down = { };

    # Workspaces and overview
    "Mod+J".focus-workspace-down = { };
    "Mod+K".focus-workspace-up = { };
    "Mod+A".toggle-overview = { };

    # Volume and brightness
    "XF86AudioRaiseVolume" = locked "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
    "XF86AudioLowerVolume" = locked "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
    "XF86AudioMute" = locked "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    "XF86AudioMicMute" = locked "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    "XF86MonBrightnessUp" = locked "brightnessctl -e4 -n2 set 5%+";
    "XF86MonBrightnessDown" = locked "brightnessctl -e4 -n2 set 5%-";

    # Media
    "XF86AudioNext" = locked "playerctl next";
    "XF86AudioPause" = locked "playerctl play-pause";
    "XF86AudioPlay" = locked "playerctl play-pause";
    "XF86AudioPrev" = locked "playerctl previous";
    "XF86AudioStop" = locked "playerctl stop";
  }
  // workspaceBinds;
}
