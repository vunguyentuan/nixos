{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../hosts/desktop
    inputs.xremap-flake.nixosModules.default
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.gfxmodeEfi = "1920x1080,auto";
  boot.loader.grub.gfxmodeBios = "1920x1080,auto";

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
  networking.extraHosts =
    ''
      127.0.0.1 local.wisorylab.com
      127.0.0.1 dev-cms.wisorylab.com
      127.0.0.1 dev-cms.wisory.io
    '';

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
    videoDrivers = [ "amdgpu" ];
  };

  #NvidiaConfig
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      amdvlk
    ];
  };

  hardware.keyboard.qmk.enable = true;

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
    serviceMode = "user"; # run xremap as user
    userName = "vunguyen";
    withHypr = true;
    yamlConfig = ''
      keymap:
        - name: MacOS
          application:
            not: [Alacritty, kitty]
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


  # media group to be used by each service
  users.groups.media = {
    gid = 1800;
    members = [
      "vunguyen"
    ];
  };

  # radarr
  services.radarr = {
    enable = true;
    group = "media";

  };

  # Jellyfin
  services.jellyfin = {
    enable = true;
    group = "media";
  };

  # prowlarr
  services.prowlarr = {
    enable = true;
  };

  services.transmission = {
    enable = true; #Enable transmission daemon
    openRPCPort = true; #Open firewall for RPC
  };

  programs.zsh.enable = true;

  # add /.local to $PATH
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    PATH = [ "\${HOME}/.local/bin" "\${HOME}/.config/rofi/scripts" ];
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  environment.systemPackages = with pkgs; [
    pkgs.fnm
    pkgs.wlogout
    pkgs.jellyfin
    pkgs.radarr
    pkgs.prowlarr
    clinfo
    obs-studio
    nodejs
    gthumb
    git
    alacritty
    contour
    fish
    neovim
    fzf
    lazygit
    bat
    eza
    ripgrep
    tmux
    firefox
    kitty
    python3
    pkgs.vial
    pkgs.wev
    pkgs.youtube-dl
    pkgs.sd
    pkgs.fd
    pkgs.yazi
    pkgs.lazydocker
    # transmission
    transgui
    nixfmt
    ddev
    mkcert
    pkgs.pritunl-client
  ];

  systemd.packages = [ pkgs.pritunl-client ];
  systemd.targets.multi-user.wants = [ "pritunl-client.service" ];

  # Allow Xdebug to use port 9003.
  networking.firewall.allowedTCPPorts = [ 9003 ];

  # Make it possible for ddev to modify the /etc/hosts file.
  # Otherwise you'll have to manually change the
  # hosts configuration after creating a new ddev project.
  environment.etc.hosts.mode = "0644";

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  users.defaultUserShell = pkgs.zsh;
  users.users.vunguyen = {
    isNormalUser = true;
    description = "Vu Nguyen";
    useDefaultShell = true;
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

  programs._1password-gui = {
    enable = true;

    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "vunguyen" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  #Garbage colector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.autoUpgrade = {
    enable = false;
    channel = "https://nixos.org/channels/nixos-23.05";
  };

  system.stateVersion = "23.05";

  #Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
