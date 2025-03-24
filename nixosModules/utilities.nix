{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    lsd
    fastfetch
    alacritty
    inputs.ghostty.packages."${pkgs.system}".default
    fzf
    unzip
    btop
    exfatprogs # Add this to format drives with exFAT fs.
    amdgpu_top # Add this to check GPU usage stats.
    parted
    dig
    ventoy-full
    stow # Manage user config files
  ];

  programs = {
    neovim.enable = true;
    fish.enable = true;
    starship.enable = true;
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  services.teamviewer.enable = true;
}

