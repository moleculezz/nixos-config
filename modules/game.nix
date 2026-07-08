{
  flake.modules.nixos.game = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
    ];

    programs.steam.enable = true;
  };
}
