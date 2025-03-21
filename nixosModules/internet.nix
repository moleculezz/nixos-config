{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
    zapzap
    localsend
    signal-desktop
  ];
}

