{ lib, ... }:

let
  lua = lib.generators.mkLuaInline;

  bind = keys: dispatcher: {
    _args = [
      keys
      (lua dispatcher)
    ];
  };

  bindWith = keys: dispatcher: flags: {
    _args = [
      keys
      (lua dispatcher)
      flags
    ];
  };

  withMainMod = keys: lua ''mainMod .. " + ${keys}"'';

  workspaceBinds =
    lib.concatMap
      (
        workspace:
        let
          key = if workspace == 10 then "0" else toString workspace;
        in
        [
          (bind (withMainMod key) "hl.dsp.focus({ workspace = ${toString workspace} })")
          (bind (withMainMod "SHIFT + ${key}") "hl.dsp.window.move({ workspace = ${toString workspace} })")
        ]
      )
      [
        1
        2
        3
        4
        5
        6
        7
        8
        9
        10
      ];
in
{
  wayland.windowManager.hyprland.settings = {
    fileManager._var = "Thunar";
    mainMod._var = "SUPER";
    terminal._var = "alacritty";

    bind = [
      # General
      (bind (withMainMod "Return") "hl.dsp.exec_raw(terminal)")
      (bind (withMainMod "E") "hl.dsp.exec_cmd(fileManager)")
      (bind (withMainMod "X") ''hl.dsp.exec_cmd("oniux AyuGram")'')
      (bind (withMainMod "B") ''hl.dsp.exec_cmd("firefox")'')
      (bind (withMainMod "Q") "hl.dsp.window.close()")
      (bind (withMainMod "SHIFT + R") ''hl.dsp.exec_cmd("hyprctl reload")'')
      (bind (withMainMod "F") ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'')
      (bind (withMainMod "I") ''hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'')
      (bind (withMainMod "D") ''hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle")'')
      (bind (withMainMod "L") ''hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock")'')
      (bind (withMainMod "space") ''hl.dsp.window.float({ action = "toggle" })'')
      (bind (withMainMod "Tab") ''hl.dsp.exec_cmd("noctalia-shell ipc call controlCenter toggle")'')
      (bind (withMainMod "Escape") ''hl.dsp.exec_cmd("noctalia-shell ipc call sessionMenu toggle")'')
      (bind (withMainMod "SHIFT + S") ''hl.dsp.exec_cmd("/home/wardar/.local/bin/screenshot.sh")'')
      (bind "Print" ''hl.dsp.exec_cmd("/home/wardar/.local/bin/screenshot.sh")'')

      # Window navigation
      (bind (withMainMod "left") ''hl.dsp.focus({ direction = "left" })'')
      (bind (withMainMod "right") ''hl.dsp.focus({ direction = "right" })'')
      (bind (withMainMod "up") ''hl.dsp.focus({ direction = "up" })'')
      (bind (withMainMod "down") ''hl.dsp.focus({ direction = "down" })'')
    ]
    ++ workspaceBinds
    ++ [
      # Volume and brightness
      (bindWith "XF86AudioRaiseVolume"
        ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")''
        {
          locked = true;
          repeating = true;
        }
      )
      (bindWith "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'' {
        locked = true;
        repeating = true;
      })
      (bindWith "XF86AudioMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'' {
        locked = true;
        repeating = true;
      })
      (bindWith "XF86AudioMicMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'' {
        locked = true;
        repeating = true;
      })
      (bindWith "XF86MonBrightnessUp" ''hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+")'' {
        locked = true;
        repeating = true;
      })
      (bindWith "XF86MonBrightnessDown" ''hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-")'' {
        locked = true;
        repeating = true;
      })

      # Media
      (bindWith "XF86AudioNext" ''hl.dsp.exec_cmd("playerctl next")'' { locked = true; })
      (bindWith "XF86AudioPause" ''hl.dsp.exec_cmd("playerctl play-pause")'' { locked = true; })
      (bindWith "XF86AudioPlay" ''hl.dsp.exec_cmd("playerctl play-pause")'' { locked = true; })
      (bindWith "XF86AudioPrev" ''hl.dsp.exec_cmd("playerctl previous")'' { locked = true; })
      (bindWith "XF86AudioStop" ''hl.dsp.exec_cmd("playerctl stop")'' { locked = true; })

      # Mouse
      (bindWith (withMainMod "mouse:272") "hl.dsp.window.drag()" { mouse = true; })
      (bindWith (withMainMod "mouse:273") "hl.dsp.window.resize()" { mouse = true; })
    ];
  };
}
