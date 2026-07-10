{ config, inputs, ... }:
let
  username = config.settings.username;
  name = config.settings.name;
  hostname = config.settings.hostname;
  hostId = config.settings.hostId;
  timezone = config.settings.timezone;
  locale = config.settings.locale;
  keyboardLayout = config.settings.keyboardLayout;
in {
  flake.modules.nixos.core = { pkgs, ... }: {
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

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Add ZFS support
    boot.supportedFilesystems = ["zfs"];
    boot.zfs.forceImportRoot = false;
    networking.hostId = hostId;

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

    networking.hostName = hostname; # Define your hostname.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    # Bootup taking over 3 minutes. NetworkManager-wait-online.service takes almost 2 minutes.
    # Disable the service.
    systemd.services.NetworkManager-wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;

    # Set your time zone.
    time.timeZone = timezone;

    # Select internationalisation properties.
    i18n.defaultLocale = locale;
    console = {
      useXkbConfig = true; # use xkb.options in tty.
    };

    services.xserver = {
      enable = true;
      xkb = {
        variant = "";
        layout = keyboardLayout;
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
      settings.Policy.AutoEnable = "true";
      settings.General.Enable = "Source,Sink,Media,Socket";
    };

    # Hibernate is unsafe here for two independent reasons, neither a quick fix:
    # - ZFS root: NixOS's zfs.nix always sets `nohibernate` unless
    #   boot.zfs.unsafeAllowHibernation is set, since resuming with an imported
    #   pool risks corruption.
    # - Framework 13 AMD 7040 + amdgpu has an open kernel bug causing
    #   reboot/black-screen instead of resume (NixOS/nixpkgs#413932).
    systemd.targets.hibernate.enable = false;

    services.fwupd.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Define a user account. Don't forget to set a password with 'passwd'.
    users.defaultUserShell = pkgs.zsh;
    users.users.${username} = {
      description = name;
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "plugdev" ]; # Enable 'sudo' for the user.
      initialHashedPassword = "$y$j9T$9DM4/7clQGEAY5SsRjEuu0$56AZgy91xnZtKNAuZYEWAY160SEWHQ26uhka4lCO/LA"; # password is "changeme"
      shell = pkgs.zsh;
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      git
      wireguard-tools
    ];

    # ZFS services
    services.zfs.autoSnapshot.enable = true;
    services.zfs.autoScrub.enable = true;

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
  };
}
