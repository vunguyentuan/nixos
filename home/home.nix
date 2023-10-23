{ hyprland, pkgs, ...}: {

  imports = [
    hyprland.homeManagerModules.default
    #./environment
    ./programs
    ./scripts
    ./themes
  ];

  home = {
    username = "vunguyen";
    homeDirectory = "/home/vunguyen";
  };

  home.packages = (with pkgs; [
    
    #User Apps
    celluloid
    librewolf
    kitty
    alacritty
    bibata-cursors
    vscode
    lollypop
    lutris
    openrgb
    

    #utils
    wlr-randr
    rustup
    gnumake
    catimg
    curl
    appimage-run
    xflux
    dunst
    pavucontrol

    #misc 
    cava
    nano
    rofi
    nitch
    wget
    grim
    slurp
    wl-clipboard
    pamixer
    mpc-cli
    tty-clock
    eza
    btop
    zsh
    fzf
    lazygit

  ]) ++ (with pkgs.gnome; [ 
    nautilus
    zenity
    gnome-tweaks
    eog
    gedit
  ]);

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
