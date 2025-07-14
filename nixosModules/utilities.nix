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
    keymapp # Voyager Keyboard
    libusb1 # Voyager Keyboard
    parted
    dig
    #ventoy-full
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

  # Voyager Keyboard
  users.groups.plugdev = {};
  services.udev.enable = true;
  services.udev.extraRules = ''
    # Rules for Oryx web flashing and live training
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

    # Keymapp Flashing rules for the Voyager
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"

  '';
}

