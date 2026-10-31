_: {
  # nwg-displays writes ~/.config/niri/monitor.kdl, then tries to add an include for it to
  # config.kdl unless that file already contains the text `include "monitor.kdl"`.
  # config.kdl is read-only here, so the KDL comment below keeps that text in place.
  wayland.windowManager.niri.extraConfig = ''
    // Monitors are managed by nwg-displays: include "monitor.kdl"
    include optional=true "~/.config/niri/monitor.kdl"
  '';
}
