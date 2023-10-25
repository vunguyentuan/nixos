{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../hosts/desktop
      inputs.xremap-flake.nixosModules.default
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  #boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["nodev"];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
    pname = "distro-grub-themes";
    version = "3.1";
    src = pkgs.fetchFromGitHub {
      owner = "AdisonCavani";
      repo = "distro-grub-themes";
      rev = "v3.1";
      hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
    };
    installPhase = "cp -r customize/nixos $out";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

i18n.inputMethod = {
  enabled = "ibus";
  ibus.engines = with pkgs.ibus-engines; [ anthy ];
 };

services.xserver = {
   enable = true;
    layout = "us";
    xkbVariant = "";
    videoDrivers = ["amdgpu"];
  };



  #NvidiaConfig
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };

  programs.steam = {
   enable = true;
   remotePlay.openFirewall = true;
   dedicatedServer.openFirewall = true;
  };

  # Configure console keymap

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xremap = {
    userName = "vunguyen";
    withHypr = true;
    yamlConfig = ''
keymap:
  - name: Chrome
    application:
      not: Alacritty
    remap:
      Super-t: C-t
      Super-c: C-c
      Super-v: C-v
      Super-w: C-w
      Super-a: C-a
      Super-r: C-r
      Super-z: C-z
      Super-e: C-e
      Super-backspace: C-backspace
      Super-Left: C-Left
      Super-Right: C-Right
    '';
  };

  #usb
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # add /.local to $PATH
  environment.variables={
   NIXOS_OZONE_WL = "1";
   PATH = [
     "\${HOME}/.local/bin"
     "\${HOME}/.config/rofi/scripts"
   ];
   NIXPKGS_ALLOW_UNFREE = "1";
  };


  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  pkgs.fnm
  nodejs
  gthumb
  git
  alacritty
  fish
  zsh
	neovim
	fzf
	lazygit
	bat
	eza
	ripgrep
	tmux
	firefox
	kitty
  #  wget
  ];

  
  users.users.vunguyen = {
    isNormalUser = true;
    description = "Vu Nguyen";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      slack
      _1password-gui
      brave
      darktable
      neofetch
      lolcat
   ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Garbage colector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.autoUpgrade = {
   enable = true;
   channel = "https://nixos.org/channels/nixos-23.05";
  };
 
  system.stateVersion = "23.05";
  
  #Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
 };
}
