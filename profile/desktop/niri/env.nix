{ pkgs, ... }:
{
  wayland.windowManager.niri.settings = {
    # Also exports XCURSOR_THEME and XCURSOR_SIZE to spawned apps.
    cursor = {
      xcursor-theme = "Bibata-Modern-Classic";
      xcursor-size = 12;
    };

    environment = {
      XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons";
      QT_QPA_PLATFORM = "wayland";
    };
  };
}
