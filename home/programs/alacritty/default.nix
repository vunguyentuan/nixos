{ config, pkgs, ... }:

{
  home.file.".config/alacritty/alacritty.yml".text = ''
live_config_reload: false
env:
  TERM: xterm-256color

window:
  dynamic_padding: false
  dimensions:
    columns: 0
    lines: 0

  padding:
    x: 25
    y: 10

  opacity: 0.9

  # startup_mode: Windowed

  # Window title
  title: Alacritty

  # Allow terminal applications to change Alacritty's window title.
  # dynamic_title: true
  option_as_alt: Both
    # Font configuration
font:
  normal:
    family: JetBrainsMono Nerd Font
    style: Regular

  # Bold font face
  bold:
    style: Bold

  italic:
    family: JetBrainsMono Nerd Font
    style: Italic

  bold_italic:
    family: JetBrainsMono Nerd Font
    style: Bold Italic

  # Point size
  size: 16.0

  builtin_box_drawing: false

# If `true`, bold text is drawn using the bright color variants.
draw_bold_text_with_bright_colors: true

cursor:
  # Cursor style
  style:
    shape: Block

  unfocused_hollow: true



mouse:
  hide_when_typing: false

key_bindings:
  - { key: Paste,                                       action: Paste          }
  - { key: Copy,                                        action: Copy           }
  - { key: L,         mods: Control,                    action: ClearLogNotice }
  - { key: L,         mods: Control, mode: ~Vi|~Search, chars: "\x0c"          }
  - { key: PageUp,    mods: Shift,   mode: ~Alt,        action: ScrollPageUp   }
  - { key: PageDown,  mods: Shift,   mode: ~Alt,        action: ScrollPageDown }
  - { key: Home,      mods: Shift,   mode: ~Alt,        action: ScrollToTop    }
  - { key: End,       mods: Shift,   mode: ~Alt,        action: ScrollToBottom }
  - { key: Left,      mods: Alt,                        chars: "\x1bb"         }
  - { key: Right,     mods: Alt,                        chars: "\x1bf"         }

  # (macOS only)
  - { key: K,              mods: Super, mode: ~Vi|~Search, chars: "\x0c"                  }
  - { key: K,              mods: Super, mode: ~Vi|~Search, action: ClearHistory           }
  - { key: Key0,           mods: Super,                    action: ResetFontSize          }
  - { key: Equals,         mods: Super,                    action: IncreaseFontSize       }
  - { key: Plus,           mods: Super,                    action: IncreaseFontSize       }
  - { key: NumpadAdd,      mods: Super,                    action: IncreaseFontSize       }
  - { key: Minus,          mods: Super,                    action: DecreaseFontSize       }
  - { key: NumpadSubtract, mods: Super,                    action: DecreaseFontSize       }
  - { key: V,              mods: Super,                    action: Paste                  }
  - { key: C,              mods: Super,                    action: Copy                   }
  - { key: C,              mods: Super, mode: Vi|~Search,  action: ClearSelection         }
  - { key: H,              mods: Super,                    action: Hide                   }
  # - { key: H,              mods: Super|Alt,                action: HideOtherApplications  }
  - { key: M,              mods: Super,                    action: Minimize               }
  - { key: Q,              mods: Super,                    action: Quit                   }
  - { key: T,              mods: Super,                    chars: "\x01c"                 }
  - { key: L,              mods: Super,                    chars: "\x01L"                 }
  - { key: P,              mods: Super|Shift,              chars: ":FzfLua commands\n" }
  - { key: P,              mods: Super,                    chars: ":FzfLua files\n" }
  - { key: S, mods: Super, chars: "\x1b\x3a\x77\x0a" } # save vim buffer
  - { key: G, mods: Super, chars: "\x01g" } # open git manager 'jesseduffield/lazygit'
  - { key: J, mods: Super, chars: "\x01\x54" }
  - { key: W,              mods: Super,                    chars: "\x01x"                 }
  - { key: N,              mods: Super|Shift,                    action: SpawnNewInstance       }
  - { key: N,              mods: Super,                    chars: "\x0e"       }
  - { key: F,              mods: Super|Control,            action: ToggleFullscreen       }
  - { key: F,              mods: Super, mode: ~Search,     action: SearchForward          }
  - { key: B,              mods: Super, mode: ~Search,     action: SearchBackward         }
  # - { key: Return,         mods: Super,                    action: ToggleSimpleFullscreen }

  - { key: Key1, mods: Super, chars: "\x011" } # select tmux window 1
  - { key: Key2, mods: Super, chars: "\x012" } #                ... 2
  - { key: Key3, mods: Super, chars: "\x013" } #                ... 3
  - { key: Key4, mods: Super, chars: "\x014" } #                ... 4
  - { key: Key5, mods: Super, chars: "\x015" } #                ... 5
  - { key: Key6, mods: Super, chars: "\x016" } #                ... 6
  - { key: Key7, mods: Super, chars: "\x017" } #                ... 7
  - { key: Key8, mods: Super, chars: "\x018" } #                ... 8
  - { key: Key9, mods: Super, chars: "\x019" } #                ... 9
  '';
}
