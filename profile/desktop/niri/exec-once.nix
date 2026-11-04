_: {
  wayland.windowManager.niri.settings._children = [
    { spawn-at-startup = "AyuGram"; }
    { spawn-at-startup = "noctalia-shell"; }
    { spawn-at-startup = "nm-applet"; }
    { spawn-at-startup = "/home/wardar/projects/CatDance-niri/catdance"; }
  ];
  wayland.windowManager.niri.extraConfig = ''
    include optional=true "/home/wardar/projects/CatDance-niri/niri/catdance.kdl"
  '';
}
