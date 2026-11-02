_:

let
  easeOutQuint = [
    "cubic-bezier"
    0.23
    1
    0.32
    1
  ];
  quick = [
    "cubic-bezier"
    0.15
    0
    0.1
    1
  ];
  # Hyprland's built-in "default" bezier.
  hyprDefault = [
    "cubic-bezier"
    0
    0.75
    0.15
    1
  ];

  # Hyprland's "popin 87%": scale between 87% and 100% while fading.
  popin = fn: progress: ''
    vec4 ${fn}(vec3 coords_geo, vec3 size_geo) {
        float p = ${progress};
        float scale = mix(0.87, 1.0, p);
        vec3 coords = vec3((coords_geo.xy - vec2(0.5)) / scale + vec2(0.5), 1.0);
        vec4 color = texture2D(niri_tex, (niri_geo_to_tex * coords).st);
        return color * p;
    }
  '';
in
{
  wayland.windowManager.niri.settings = {
    layout = {
      # Hyprland's gaps_in applies to each window side (10px between windows),
      # gaps_out is 5px at the screen edges.
      gaps = 10;
      struts = {
        left = -5;
        right = -5;
        top = -5;
        bottom = -5;
      };

      focus-ring.off = { };

      border = {
        off = { };
        active-gradient._props = {
          from = "#ffffffaa";
          to = "#000000ee";
          angle = 45;
        };
        inactive-color = "#222222aa";
      };

      shadow = {
        on = { };
        softness = 15;
        spread = 0;
        offset._props = {
          x = 0;
          y = 0;
        };
        color = "#1a1a1aee";
        inactive-color = "#1a1a1aee";
      };
    };

    blur = {
      passes = 5;
      offset = 7.0;
      noise = 0.02;
    };

    _children = [
      {
        window-rule = {
          geometry-corner-radius = 12;
          clip-to-geometry = true;
          background-effect.blur = true;
        };
      }
      {
        # noctalia's blurred wallpaper (wallpaper.overviewEnabled) shows behind the overview.
        layer-rule = {
          match._props.namespace = "^noctalia-overview";
          place-within-backdrop = true;
        };
      }
    ];

    animations = {
      window-movement = {
        duration-ms = 479;
        curve = easeOutQuint;
      };
      window-resize = {
        duration-ms = 479;
        curve = easeOutQuint;
      };
      window-open = {
        duration-ms = 410;
        curve = easeOutQuint;
        custom-shader = popin "open_color" "niri_clamped_progress";
      };
      window-close = {
        duration-ms = 149;
        curve = quick;
        custom-shader = popin "close_color" "1.0 - niri_clamped_progress";
      };
      workspace-switch = {
        duration-ms = 194;
        curve = hyprDefault;
      };
    };
  };
}
