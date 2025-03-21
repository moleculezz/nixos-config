{ pkgs, lib, config, ... }:
{
  options.my.fonts.enable = lib.mkEnableOption "Enable My Fonts";

  config = lib.mkIf config.my.fonts.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      font-awesome
      jetbrains-mono
      carlito
      caladea
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "JetBrainsMono"
        ];
      })
    ];
  };
}
