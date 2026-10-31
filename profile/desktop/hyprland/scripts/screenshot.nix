_:

{
  home.file.".local/bin/screenshot" = {
    executable = true;

    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      DIR="$HOME/Pictures/Screenshots"
      mkdir -p "$DIR"

      if [[ "''${1:-}" == "--all" ]]; then
        NAME="all-screens"
      else
        NAME="$(
          hyprctl activewindow -j \
            | jq -r '.class // .initialClass // "unknown"' \
            | tr '/:*?"<>| ' '_'
        )"
      fi

      FILE="$DIR/''${NAME}-$(date +'%Y-%m-%d_%H-%M-%S').png"

      if [[ "''${1:-}" == "--all" ]]; then
        grim "$FILE"
      else
        GEOMETRY="$(slurp)" || exit 0
        grim -g "$GEOMETRY" "$FILE"
      fi

      wl-copy < "$FILE"

      notify-send \
        -i camera-photo \
        "Скриншот сохранён" \
        "$FILE"
    '';
  };
}
