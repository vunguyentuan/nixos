{ config, pkgs, user, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  users.groups.docker.members = [ "vunguyen" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
