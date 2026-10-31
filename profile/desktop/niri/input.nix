_: {
  wayland.windowManager.niri.settings.input = {
    focus-follows-mouse = { };

    keyboard.xkb = {
      layout = "us,ru";
      options = "grp:alt_shift_toggle";
    };

    mouse = {
      accel-speed = 0.0;
      scroll-factor = 1.0;
      scroll-method = "on-button-down";
      scroll-button = 276;
    };

    # Leaving out `dwt` keeps disable-while-typing off.
    touchpad = {
      tap = { };
      natural-scroll = { };
    };
  };
}
