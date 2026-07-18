{
  flake.modules.nixos.development = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git-credential-manager
      gh
      devenv
      code-cursor
      claude-code
    ];
  };
}
