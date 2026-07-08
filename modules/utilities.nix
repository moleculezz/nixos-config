{
  flake.modules.nixos.utilities = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      lsd
      fastfetch
      alacritty
      ghostty
      fzf
      unzip
      btop
      exfatprogs # Add this to format drives with exFAT fs.
      amdgpu_top # Add this to check GPU usage stats.
      keymapp # Voyager Keyboard
      libusb1 # Voyager Keyboard
      parted
      nmap
      net-tools
      pciutils
      usbutils
      ncurses
      dig
      unifi
      #ventoy-full
      stow # Manage user config files
    ];
    programs.partition-manager.enable = true;  # NixOS 23.11+
    programs = {
      zsh = {
        enable = true;
        autosuggestions.enable = true;
        enableCompletion = true;
        zsh-autoenv.enable = true;
        syntaxHighlighting.enable = true;
        ohMyZsh = {
          enable = true;
          plugins = [
            "git"
            "history"
          ];
        };
      };
      starship.enable = true;
      zoxide.enable = true;
    };

    programs.wireshark.enable = true;
    programs.wireshark.package = pkgs.wireshark;
    #users.users..extraGroups = [ "wireshark" ];

    services.teamviewer.enable = true;
    services.unifi.enable = true;
    services.unifi.unifiPackage = pkgs.unifi;
    services.unifi.mongodbPackage = pkgs.mongodb-ce;
    #services.mongodb.enable = true;
    #services.mongodb.package = pkgs.mongodb-ce;
    networking.firewall.allowedTCPPorts = [
      8080   # Device inform (already have this)
      8443   # Controller web interface and device management
      8880   # HTTP portal redirect
      8843   # HTTPS portal redirect
      6789   # Speed test
    ];
    networking.firewall.allowedUDPPorts = [
      3478   # STUN for remote access
      10001  # Device discovery
    ];

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
  };
}
