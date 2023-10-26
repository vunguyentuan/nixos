{ config, pkgs, ... }:

{
    programs = {
        zsh = {
            enable = true;
            oh-my-zsh = {
                enable = true;
                theme = "refined";
                plugins = [
                    "git"
                ];
            };

            enableAutosuggestions = true;
            enableCompletion = true;
            syntaxHighlighting.enable = true;
        };
    };

    home.file.".zshrc".text = ''
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

# eval "$(fnm env --use-on-cd)"

ZSH_THEME="refined"
REFINED_CHAR_SYMBOL="⚡"

# Rofi
export PATH=$HOME/.config/rofi/scripts:$PATH
export PATH=$PATH:~/Apps

# aliases
alias v="nvim"
alias lg="lazygit"
alias ld="lazydocker"

    '';
}
