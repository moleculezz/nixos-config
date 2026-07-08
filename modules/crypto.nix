{
  flake.modules.nixos.crypto = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      cryptsetup #LUKS setup
      yubikey-manager #FIDO2 setup
      yubioath-flutter
      #trezor-suite #Crypto Wallet
      #trezor-udev-rules
      #trezorctl
    ];
  };
}
