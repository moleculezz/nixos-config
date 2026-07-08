{
  flake.modules.nixos.multimedia = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      vlc
      gimp3
      inkscape
      #freecad
      ffmpeg
      affinity-v3
    ];
  };
}
