{ lib, ... }:

let
  files = builtins.attrNames (builtins.readDir ./.);
in
{
  imports = map (name: ./. + "/${name}") (
    builtins.filter (name: lib.hasSuffix ".nix" name && name != "default.nix") files
  );
}
