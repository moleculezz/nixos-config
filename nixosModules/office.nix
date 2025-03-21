{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice-qt-fresh # QT version for KDE
    obsidian
    pdfstudio2024 # NonFree pdf editor, similar to Acrobat
    speedcrunch
  ];
}
