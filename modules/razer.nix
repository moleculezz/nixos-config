{ config, ... }:
let
  username = config.settings.username;
in {
  flake.modules.nixos.razer = { pkgs, ... }: {
    hardware.openrazer.enable = true;
    hardware.openrazer.users = [ username ];

    environment.systemPackages = with pkgs; [
      razergenie
    ];
  };
}
