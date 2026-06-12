{ config, pkgs, inputs, systemSettings, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc
    gimp3
    inkscape
    #davinci-resolve
    #freecad
    ffmpeg
    affinity-v3
  ];
}
