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

    # Let 1Password's browser integration trust the wrapped zen-browser binary.
    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          .zen-wrapped
        '';
        mode = "0755";
      };
    };

    services.syncthing = {
      enable = true;
      user = username;
      dataDir = "${homeDir}/syncthing";
      configDir = "${homeDir}/.config/syncthing";

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
