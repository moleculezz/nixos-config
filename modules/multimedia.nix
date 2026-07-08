{
  flake.modules.nixos.multimedia = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      vlc
      gimp3
      inkscape
      #davinci-resolve
      #freecad
      ffmpeg
      affinity-v3
    ];
  };
}
