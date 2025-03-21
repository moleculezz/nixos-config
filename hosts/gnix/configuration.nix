# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, systemSettings, userSettings, ... }:

{
  # This displays the changes made when doing a nix rebuild switch
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
        /run/current-system "$systemConfig"
    '';
  };

  nix = {
    package = pkgs.nixVersions.stable;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d"; 
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  # boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Add ZFS support
  boot.supportedFilesystems = ["zfs"];
  networking.hostId = "06919496";

  # Add LUKS & Yubikey
  # https://discourse.nixos.org/t/fde-using-systemd-cryptenroll-with-fido2-key/47762/1
  # https://research.kudelskisecurity.com/2023/12/14/luks-disk-encryption-with-fido2/
  boot.initrd = {
    systemd.enable = true;  # initrd uses systemd
    luks.fido2Support = false;  # because systemd
    luks.devices.nvme0n1p3_encrypted = {
      device = "/dev/disk/by-partlabel/disk-nvme-luks";
      crypttabExtraOpts = ["fido2-device=auto"];  # cryptenroll
    };
  };

  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ userSettings.username ];

  # Davinci Resolve
  hardware.graphics = {
   enable = true;
   extraPackages = with pkgs; [
     rocmPackages.clr.icd
   ];
 };

  networking.hostName = systemSettings.hostname; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Aruba";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.xserver = {
    enable = true;
    xkb = {
      variant = "";
      layout = "us";
    };
  };
  services.libinput.enable = true;

  services.desktopManager.plasma6.enable = true;


  # Enable pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # package = pkgs.bluez5-experimental;
    settings.Policy.AutoEnable = "true";
    settings.General.Enable = "Source,Sink,Media,Socket";
  };
  #services.blueman.enable = true;
  
  systemd.targets.hibernate.enable = false; #issue with reboot. It hibernates and won't boot up. Fix later

  services.fwupd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #users.mutableUsers = false;
  users.users.${userSettings.username} = {
    description = userSettings.name;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ]; # Enable ‘sudo’ for the user.
    initialHashedPassword = "$y$j9T$9DM4/7clQGEAY5SsRjEuu0$56AZgy91xnZtKNAuZYEWAY160SEWHQ26uhka4lCO/LA"; # password is "changeme"
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    gcc # Needed for neovim
    ripgrep # Neovim
    razergenie
    wireguard-tools
    #kdePackages.dolphin
    #pavucontrol # Add this to manage audio controls.
    #brightnessctl # Add this to control device brightness
    #playerctl # Add this to control media players play/pause etc.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ userSettings.username ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # ZFS services
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

