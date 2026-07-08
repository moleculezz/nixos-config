{ config, inputs, ... }:
let
  username = config.settings.username;
  homeDir = config.settings.homeDir;
in {
  flake.modules.nixos.internet = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      firefox
      google-chrome
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      zapzap
      localsend
      syncthingtray
      signal-desktop
    ];

    services.syncthing = {
      enable = true;
      user = username;
      dataDir = "${homeDir}/syncthing";
      configDir = "${homeDir}/.config/syncthinig";

      settings.devices = {
        TrueNAS = {
          addresses = [ "tcp://10.8.8.200:22000" ];
          id = "TFBEDUT-66QUUTP-DRGP5NP-QKBPSLE-2WYVD7C-J5PP3XI-DKCLE6P-KHG5OAB";
        };
      };

      settings.folders = {
        "${homeDir}/Documents" = {
          id = "Documents";
          label = "GD's Documents";
          devices = [ "TrueNAS" ];
        };
      };
    };
  };
}
