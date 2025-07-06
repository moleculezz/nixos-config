{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc
    gimp3
    inkscape
    #davinci-resolve
    freecad
    ffmpeg
  ];
}
