{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    shortcut = "a";

    extraConfig = ''
set -g renumber-windows on   # renumber all windows when any window is closed
set -g set-clipboard on      # use system clipboard
set -g status-interval 3     # update the status bar every 3 seconds

set -g escape-time 0         # zero-out escape time delay

set -g status-left "#[fg=blue,bold]#S"
set -ga status-left " #[fg=white,nobold]#(gitmux -cfg $HOME/.config/tmux/gitmux.conf)"
set -g status-left-length 200            # increase length (from 10)
set -g status-position top               # macOS / darwin style
set -g status-right-length 6             # decrease length (from 10)
set -g status-style 'bg=default'         # transparent

set -g window-status-current-format '#[fg=magenta]#W'
set -g window-status-format '#[fg=gray]#W'

set -g message-command-style bg=default,fg=yellow
set -g message-style bg=default,fg=yellow
set -g mode-style bg=default,fg=yellow
set -g pane-active-border-style 'fg=magenta,bg=default'
set -g pane-border-style 'fg=brightblack,bg=default'

# keybindings
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

bind v split-window -h -c "#{pane_current_path}"
bind s split-window -v -c "#{pane_current_path}"

bind-key -T copy-mode-vi y send-keys -X copy-selection
bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

# Copy from tmux buffer to clipboard
# Require reattach-to-user-namespace
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy" \; display-message "Copied to clipboard"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy" \; display-message "Copied to clipboard"

bind c new-window -c '#{pane_current_path}'
bind g new-window -n '?' lazygit
bind G new-window -n '?' gh dash
    '';

    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
          set -g @fzf-url-history-limit '2000'
          set -g @t-fzf-prompt '  '
        '';
      }
    ];
  };
}
