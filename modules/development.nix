{
  flake.modules.nixos.development = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git-credential-manager
      gh
      code-cursor
      claude-code
    ];

    programs.git.config = {
      init.defaultBranch = "main";
    };
  };
}
