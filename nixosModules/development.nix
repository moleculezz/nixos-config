{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git-credential-manager
    gh
    code-cursor
    claude-code
  ];
}

