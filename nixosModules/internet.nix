{ config, pkgs, inputs, userSettings, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
    zapzap
    inputs.zen-browser.packages."${pkgs.system}".default
    localsend
    syncthingtray
    signal-desktop
  ];

  services.syncthing = {
    enable = true;
    user = userSettings.username;
    dataDir = "${userSettings.homeDir}/syncthing";
    configDir = "${userSettings.homeDir}/.config/syncthinig";

    settings.devices = {
      TrueNAS = {
        addresses = [ "tcp://10.8.8.200:22000" ];
        id = "TFBEDUT-66QUUTP-DRGP5NP-QKBPSLE-2WYVD7C-J5PP3XI-DKCLE6P-KHG5OAB";
      };
    };

    settings.folders = {
      "${userSettings.homeDir}/Documents" = {
        id = "Documents";
        label = "GD's Documents";
        devices = [ "TrueNAS" ];
      };
    };
  };
}

