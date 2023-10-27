{
  config,
  pkgs,
  lib,
  ...
}: {
  services.swayidle = {
      enable = true;

      # TODO: Make dynamic for window manager
      events = [
        {
          event = "before-sleep";
          command = "swaylock -df";
        }
        {
          event = "after-resume";
          command = "hyprctl dispatch dpms on";
        }
        {
          event = "lock";
          command = "swaylock -df";
        }
      ];

      timeouts = [
        {
          timeout = 900;
          command = "swaylock -df";
        }
        {
          timeout = 1200;
          command = "hyprctl dispatch dpms off";
        }
      ];
    };

}
