{
  flake.modules.nixos.game = { ... }: {
    programs.steam.enable = true;
  };
}
