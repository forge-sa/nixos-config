_: {
  wayland.windowManager.hyprland.settings = {
    config = {
      animations.enabled = true;

      decoration = {
        active_opacity = 1.0;
        blur = {
          brightness = 1.0;
          contrast = 1.0;
          enabled = true;
          ignore_opacity = true;
          new_optimizations = true;
          noise = 0.02;
          passes = 5;
          size = 7;
          vibrancy = 0.5;
          vibrancy_darkness = 0.5;
        };
        fullscreen_opacity = 1.0;
        inactive_opacity = 1.0;
        rounding = 12;
        shadow = {
          color = "rgba(1a1a1aee)";
          enabled = true;
          range = 15;
          render_power = 3;
        };
      };

      general = {
        border_size = 0;
        col = {
          active_border = {
            colors = [
              "rgba(ffffffaa)"
              "rgba(000000ee)"
            ];
            angle = 45;
          };
          inactive_border = "rgba(222222aa)";
        };
        gaps_in = 5;
        gaps_out = 5;
        layout = "dwindle";
        resize_on_border = false;
      };
    };

    curve = [
      {
        _args = [
          "easeOutQuint"
          {
            type = "bezier";
            points = [
              [
                0.23
                1
              ]
              [
                0.32
                1
              ]
            ];
          }
        ];
      }
      {
        _args = [
          "quick"
          {
            type = "bezier";
            points = [
              [
                0.15
                0
              ]
              [
                0.1
                1
              ]
            ];
          }
        ];
      }
    ];

    animation = [
      {
        leaf = "windows";
        enabled = true;
        speed = 4.79;
        bezier = "easeOutQuint";
      }
      {
        leaf = "windowsIn";
        enabled = true;
        speed = 4.1;
        bezier = "easeOutQuint";
        style = "popin 87%";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 1.49;
        bezier = "quick";
        style = "popin 87%";
      }
      {
        leaf = "fadeIn";
        enabled = true;
        speed = 1.73;
        bezier = "default";
      }
      {
        leaf = "fadeOut";
        enabled = true;
        speed = 1.46;
        bezier = "default";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 1.94;
        bezier = "default";
        style = "slide";
      }
    ];
  };
}
