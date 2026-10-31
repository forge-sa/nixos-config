{ lib, ... }:
{
  wayland.windowManager.hyprland.settings.on = {
    _args = [
      "hyprland.start"
      (lib.generators.mkLuaInline ''
        function()
          hl.exec_cmd("AyuGram")
          hl.exec_cmd("noctalia-shell")
          hl.dispatch(hl.dsp.exec_raw("nm-applet &"))
	  hl.exec_cmd("/home/wardar/projects/CatDance/catdance")
        end
      '')
    ];
  };
}
