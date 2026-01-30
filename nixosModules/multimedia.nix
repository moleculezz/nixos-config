{ config, pkgs, inputs, systemSettings, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc
    gimp3
    inkscape
    #davinci-resolve
    #freecad
    ffmpeg
    inputs.affinity-nix.packages.${pkgs.system}.v3
  ];
}
