{ pkgs, ... }:
{
  wayland.windowManager.hyprland.settings.env = [
    {
      _args = [
        "XCURSOR_THEME"
        "Bibata-Modern-Classic"
      ];
    }
    {
      _args = [
        "XCURSOR_SIZE"
        "12"
      ];
    }
    {
      _args = [
        "XCURSOR_PATH"
        "${pkgs.bibata-cursors}/share/icons"
      ];
    }
    {
      _args = [
        "QT_QPA_PLATFORM"
        "wayland"
      ];
    }
  ];
}
