{
  flake.modules.nixos.davinci-resolve = { pkgs, ... }: {
    # ROCm support needed for Davinci Resolve
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    environment.systemPackages = with pkgs; [
      davinci-resolve
    ];
  };
}
