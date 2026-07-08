{
  flake.modules.nixos.neovim = { pkgs, ... }: {
    programs.neovim.enable = true;

    environment.systemPackages = with pkgs; [
      gcc # Needed for neovim
      ripgrep # Neovim
    ];
  };
}
