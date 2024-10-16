{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc
    gimp
    inkscape
  ];
}
