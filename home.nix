{ pkgs, ... }:

{
  home = rec {
    username="lune";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
  };

  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "ibus";
  };

  programs.home-manager.enable = true; # home-manager自身でhome-managerを有効化
}
